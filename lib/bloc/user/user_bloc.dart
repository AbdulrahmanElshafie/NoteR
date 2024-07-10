import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:noter/models/note.dart';
import 'package:noter/models/tag.dart';
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



  }


  void logout() {
    firebaseService.logout();
  }

  Future<void> login(UserEventLogin event, Emitter emit) async {
    emit(UserLoading());
    String salt;
    try {
      salt = await firebaseService.getSalt(event.email);
      await firebaseService.login(event.email, event.password, salt);
      var userData = await firebaseService.getUserInfo(event.email);

      user = UserAccount.fromMap(userData.data() as Map<String, dynamic>);

    } on Error catch (e) {
      emit(UserError(e.toString()));
      return;
    }

    emit(UserLoggedIn());
  }

  Future<void> register(UserEventRegister event, Emitter emit) async {
    emit(UserLoading());
    String salt;
    try {
      salt = await firebaseService.register(event.email, event.password);
      await firebaseService.addUserToDb(event.name, event.email, salt,
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
      await firebaseService.updateUserInfo(event.email, event.name, event.location, event.language);
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
      var notes = await firebaseService.getNotes(event.email);
      for(var element in notes.docs) {
        Note note = Note.fromMap(element.data());
        user.notes.add(note);
      }
    } catch (e) {
      emit(UserError(e.toString()));
      return;
    }
    emit(UserSuccess('All good!'));
  }

  Future<void> getTags(UserEventGetTags event, Emitter emit) async {
    emit(UserLoading());
    try {
      var tags = await firebaseService.getTags(event.email);
      for(var element in tags.docs) {
        Tag tag = Tag.fromMap(element.data());
        user.tags.add(tag);
      }
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
