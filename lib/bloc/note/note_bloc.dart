import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:noter/models/note.dart';
import 'package:noter/models/tag.dart';
import 'package:noter/shared/network/remote/firebase_service.dart';


part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  FirebaseService firebaseService = FirebaseService();

  NoteBloc() : super(NoteInitial()) {
    on<NoteEventUpdateNote>((event, emit) async {
      await saveNote(event, emit);
    });

    on<NoteEventAddNote>((event, emit) async {
      await saveNote(event, emit);
    });

    on<NoteEventDeleteNote>((event, emit) async {
        await deleteNote(event, emit);
    });

    // on<NoteEventGetNote>((event, emit) async {
    //     await getNote(event, emit);
    // });

    on<NoteEventAddTag>((event, emit) async {
      await addTag(event, emit);
    });

    on<NoteEventRemoveTag>((event, emit) async {
      await removeTag(event, emit);
    });

  }

  Future<void> saveNote(NoteEventSaveNote event, Emitter emit) async {
    emit(SavingNote());

    try {
      if(event is NoteEventAddNote) {
        await firebaseService.addNoteToDb(event.email, event.note);

      } else if(event is NoteEventUpdateNote) {
        await firebaseService.updateNoteDetails(event.email, event.note);

      }

      if(event.note.tags.isNotEmpty){
        for (var tagId in event.note.tags) {
          await firebaseService.addNoteTag(event.email, event.note.noteId, tagId);
        }

      }
    } catch (e) {

      emit(NoteError(e.toString()));
      return;
    }

    emit(NoteSuccess('Note Saved Successfully!'));
  }

  Future<void> deleteNote(NoteEventDeleteNote event, Emitter emit) async {
    emit(DeleteNote());

    try {
      await firebaseService.deleteNote(event.email, event.note);

    } catch (e) {
      emit(NoteError(e.toString()));
    }

    emit(NoteSuccess('Note Deleted Successfully!'));
  }

  // Future<Note> getNote(NoteEventGetNote event, Emitter emit) async {
  //   Note note = Note();
  //
  //   emit(GetNote());
  //   emit(NoteLoading());
  //
  //   try {
  //     var doc = await firebaseService.readNote(event.email, event.note.noteId);
  //
  //     note = Note.fromMap(doc.data() as Map<String, dynamic>);
  //     emit(NoteLoaded());
  //     return note;
  //   } catch (e) {
  //     emit(NoteError(e.toString()));
  //     return note;
  //   }
  // }

  Future<void> addTag(NoteEventAddTag event, Emitter emit) async {
    emit(AddTag());

    try {
      await firebaseService.addNoteTag(event.email, event.noteId, event.tagId);

    } catch (e) {
      emit(NoteError(e.toString()));
    }

    emit(NoteSuccess('Add Tag Successfully!'));
  }

  Future<void> removeTag(NoteEventRemoveTag event, Emitter emit) async {
    emit(RemoveTag());

    try {
      await firebaseService.deleteNoteTag(event.email, event.noteId, event.tagId);

    } catch (e) {
      emit(NoteError(e.toString()));
    }

    emit(NoteSuccess('Removed Tag Successfully!'));
  }


}

