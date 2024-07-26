import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:noter/models/note.dart';
import 'package:noter/models/tag.dart';
import 'package:noter/shared/components/GeminiAPI.dart';
import '../../shared/components/Pair.dart';
import '../../shared/network/remote/firebase_service.dart';
import 'package:noter/models/user.dart';

part 'user_event.dart';

part 'user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  FirebaseService firebaseService = FirebaseService();
  late UserAccount user;

  UserBloc() : super(UserInitial()) {
    on<UserEventRegister>((event, emit) async {
      await register(event, emit);
    });

    on<UserEventLogin>((event, emit) async {
      await login(event, emit);
    });

    on<UserEventLogout>((event, emit) async {
      await logOut(event, emit);
    });

    on<UserEventDelete>((event, emit) async {
      await deleteAccount(event, emit);
    });

    on<UserEventUpdate>((event, emit) async {
      await userUpdate(event, emit);
    });

    on<UserEventGetUserInfo>((event, emit) async {
      await getUserInfo(event, emit);
    });

    on<UserEventResetPassword>((event, emit) async {
      await resetPassword(event, emit);
    });

    on<UserEventGetNotes>((event, emit) async {
      await getNotes(event, emit);
    });

    on<UserEventGetTags>((event, emit) async {
      await getTags(event, emit);
    });

    on<UserEventLoadUser>((event, emit) async {
      await loadUser(event, emit);
    });

    on<UserEventTyping>((event, emit) async {
      await getNotesSimilarity(event, emit);
    });

    on<UserEventClear>((event, emit) {
      clearSuggestions(event, emit);
    });

    on<UserEventPrompting>((event, emit) async {
      await getResponse(event, emit);
    });
  }

  void clearSuggestions(UserEventClear event, Emitter emit) {
    emit(UserClearing());
    emit(UserSuccess('Clear'));
  }

  Future<List<Pair>> getSimilarNotes(String txt) async {
    GeminiApi geminiApi = GeminiApi();
    List<double> promptEmbedding = await geminiApi.embeddingGenerator(txt);
    return user.calcNotesSimilarity(promptEmbedding);
  }

  Future<void> getNotesSimilarity(UserEventTyping event, Emitter emit) async {
    emit(UserTyping());
    List<Pair> suggestions = [];

    try {
      suggestions = await getSimilarNotes(event.txt);
      for(int i = 0; i < suggestions.length; i++){
        if(suggestions[i].first < 0.5){
          suggestions.removeAt(i);
          i--;
        }
      }
    } catch (e) {
      emit(UserError(e.toString()));
      return;
    }

    emit(UserTypingSuccess(suggestions.length < 20
        ? suggestions
        : suggestions.sublist(0, 20)));
    // emit(UserSuccess('success'));
  }

  Future<void> getResponse(UserEventPrompting event, Emitter emit) async {
    emit(UserPrompting());

    List<Pair> suggestions = [];
    GeminiApi geminiApi = GeminiApi();
    String response = '';
    try {
      await getSimilarNotes(event.prompt).then((onValue) {
        suggestions = onValue.sublist(0, 5);
      });

      String resources = '';

      for (int i = 0; i < suggestions.length; i++) {
        Note? note = user.notes[suggestions[i].second];
        resources += '${note?.title} ${Document.fromJson(jsonDecode(note!.content)).toPlainText()}';
      }

      response = await geminiApi.chatGenerator(event.prompt, resources);
    } catch (e) {
      emit(UserError(e.toString()));
      return;
    }

    emit(UserPromptResponse(response));
  }

  void collectNotes(String email) async {
    var notes = await firebaseService.getNotes(email);

    for (int i = 0; i < notes.docs.length; i++) {
      Note note = Note.fromMap(notes.docs[i].data());
      note.noteId = notes.docs[i].id;

      var tags = await firebaseService.getTagsForNote(note.noteId, email);
      for (int j = 0; j < tags.docs.length; j++) {
        note.addTag(tags.docs[i].id);
      }

      user.addNote(note);
    }
  }

  void collectTags(String email) async {
    var tags = await firebaseService.getTags(email);

    for (int i = 0; i < tags.docs.length; i++) {
      Tag tag = Tag.fromMap(tags.docs[i].data());
      tag.tagId = tags.docs[i].id;

      var notes = await firebaseService.getNotesForTag(tag.name, email);
      for (int j = 0; j < notes.docs.length; j++) {
        tag.addNote(notes.docs[i].id);
      }

      user.addTag(tag);
    }
  }

  void logout() {
    firebaseService.logout();
  }

  Future<void> loadUser(UserEventLoadUser event, Emitter emit) async {
    emit(UserCollecting());
    try {
      var userData = await firebaseService.getUserInfo(event.email);
      user = UserAccount.fromMap(userData.data() as Map<String, dynamic>);

      collectNotes(event.email);

      collectTags(event.email);
    } catch (e) {
      emit(UserError(e.toString()));
      return;
    }
    emit(UserSuccess('User Loaded Successfully'));
  }

  Future<void> login(UserEventLogin event, Emitter emit) async {
    emit(UserLoading());
    try {
      await firebaseService.login(event.email, event.password);

      var userData = await firebaseService.getUserInfo(event.email);
      user = UserAccount.fromMap(userData.data() as Map<String, dynamic>);

      collectNotes(event.email);

      collectTags(event.email);
    } catch (e) {
      emit(UserError(e.toString()));
      return;
    }

    emit(UserLoggedIn());
  }

  Future<void> register(UserEventRegister event, Emitter emit) async {
    emit(UserLoading());
    try {
      await firebaseService.addUserToDb(event.name, event.email,
          event.gender, event.birthday, event.location, event.language);

      user = UserAccount(
          event.gender, event.birthday, event.location, event.language,
          name: event.name, email: event.email);
    } catch (e) {
      emit(UserError(e.toString()));
      return;
    }

    emit(UserLoggedIn());
  }

  Future<void> logOut(UserEventLogout event, Emitter emit) async {
    emit(UserLoading());
    try {
      await firebaseService.logout();
    } catch (e) {
      emit(UserError(e.toString()));
      return;
    }
    emit(UserLoggedOut());
  }

  Future<void> deleteAccount(UserEventDelete event, Emitter emit) async {
    emit(UserLoading());
    try {
      await firebaseService.deleteUser(event.email);
    } catch (e) {
      emit(UserError(e.toString()));
      return;
    }
    emit(UserLoggedOut());
  }

  Future<void> userUpdate(UserEventUpdate event, Emitter emit) async {
    emit(UserLoading());
    try {
      await firebaseService.updateUserInfo(
          event.email, event.name, event.location, event.language);
    } catch (e) {
      emit(UserError(e.toString()));
      return;
    }
    emit(UserSuccess('All good!'));
  }

  Future<void> getUserInfo(UserEventGetUserInfo event, Emitter emit) async {
    emit(UserLoading());
    try {
      var userData = await firebaseService.getUserInfo(event.email);
      user = UserAccount.fromMap(userData as Map<String, dynamic>);
    } catch (e) {
      emit(UserError(e.toString()));
      return;
    }
    emit(UserSuccess('All good!'));
  }

  Future<void> getNotes(UserEventGetNotes event, Emitter emit) async {
    emit(UserLoading());
    try {
      collectNotes(event.email);
    } catch (e) {
      emit(UserError(e.toString()));
      return;
    }
    emit(UserSuccess('All good!'));
  }

  Future<void> getTags(UserEventGetTags event, Emitter emit) async {
    emit(UserLoading());
    try {
      collectTags(event.email);
    } catch (e) {
      emit(UserError(e.toString()));
      return;
    }
    emit(UserSuccess('All good!'));
  }

  Future<void> resetPassword(UserEventResetPassword event, Emitter emit) async {
    emit(UserLoading());
    try {
      await firebaseService.resetPassword(event.email);
    } catch (e) {
      emit(UserError(e.toString()));
      return;
    }
    emit(UserSuccess('All good!'));
  }
}
