import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:noter/models/note.dart';
import 'package:noter/models/tag.dart';
import 'package:noter/shared/network/local/local_db_service.dart';
import 'package:noter/shared/network/remote/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';


part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  FirebaseService firebaseService = FirebaseService();
  late LocalDbService localDbService;

  NoteBloc(SharedPreferences prefs) : super(NoteInitial()) {
    localDbService = LocalDbService(prefs);

    on<NoteEventDeleteNote>((event, emit) async {
        await deleteNote(event, emit);
    });
    on<NoteEventUpdateNote>((event, emit) async {
        await updateNote(event, emit);
    });
    on<NoteEventGetNote>((event, emit) async {
        await getNote(event, emit);
    });

    on<NoteEventAddTag>((event, emit) async {
      await addTag(event, emit);
    });
    on<NoteEventRemoveTag>((event, emit) async {
      await removeTag(event, emit);
    });

    on<NoteEventSaveNote>((event, emit) async {
      await saveNote(event, emit);
    });

  }

  Future<void> saveNote(NoteEventSaveNote event, Emitter emit) async {
    emit(SavingNote());

    try {
      await firebaseService.addNoteToDb(event.email, event.note);
    } catch (e) {
      emit(NoteNotSaved());
      emit(NoteError(e.toString()));
      return;
    }

    emit(NoteSaved());
  }

  Future<void> deleteNote(NoteEventDeleteNote event, Emitter emit) async {
    emit(DeleteNote());

    try {
      await firebaseService.deleteNote(event.email, event.note);
    } catch (e) {
      emit(NoteError(e.toString()));
    }

    emit(NoteDeleted());
  }

  Future<void> updateNote(NoteEventUpdateNote event, Emitter emit) async {
    emit(UpdateNote());

    try {
      await firebaseService.updateNoteDetails(event.email, event.note);
    } catch (e) {
      emit(NoteError(e.toString()));
      return;
    }

    emit(NoteSaved());
  }

  Future<Note> getNote(NoteEventGetNote event, Emitter emit) async {
    Note note = Note();
    emit(GetNote());
    emit(NoteLoading());
    try {
      var doc = await firebaseService.readNote(event.email, event.note.noteId);
      note = Note.fromMap(doc.data() as Map<String, dynamic>);
      emit(NoteLoaded());
      return note;
    } catch (e) {
      emit(NoteError(e.toString()));
      return note;
    }
  }

  Future<void> addTag(NoteEventAddTag event, Emitter emit) async {
    emit(AddTag());

    try {
      await firebaseService.addNoteTag(event.email, event.note, event.tag);
    } catch (e) {
      emit(NoteError(e.toString()));
    }

    emit(NoteSaved());
  }

  Future<void> removeTag(NoteEventRemoveTag event, Emitter emit) async {
    emit(RemoveTag());

    try {
      await firebaseService.deleteNoteTag(event.email, event.note, event.tag);
    } catch (e) {
      emit(NoteError(e.toString()));
    }

    emit(NoteSaved());
  }


}

