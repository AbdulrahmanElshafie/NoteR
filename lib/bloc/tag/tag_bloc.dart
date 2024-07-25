import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:noter/models/tag.dart';
import '../../models/note.dart';
import '../../shared/network/remote/firebase_service.dart';

part 'tag_event.dart';
part 'tag_state.dart';

class TagBloc extends Bloc<TagEvent, TagState> {
  FirebaseService firebaseService = FirebaseService();

  TagBloc() : super(TagInitial()) {
    on<TagEventUpdateTag>((event, emit) async {
      await saveTag(event, emit);
    });

    on<TagEventAddTag>((event, emit) async {
      await saveTag(event, emit);
    });

    on<TagEventDeleteTag>((event, emit) async {
      await deleteTag(event, emit);
    });

    on<TagEventAddNote>((event, emit) async {
      await addNote(event, emit);
    });

    on<TagEventRemoveNote>((event, emit) async {
      await removeNote(event, emit);
    });

  }


  Future<void> saveTag(TagEventSaveTag event, Emitter emit) async {
    emit(SavingTag());

    try {
      if(event is TagEventAddTag) {
        await firebaseService.addTagToDb(event.email, event.tag);

      } else if(event is TagEventUpdateTag) {
        await firebaseService.updateTagDetails(event.email, event.tag);

      }

      if(event.tag.notes.isNotEmpty){
        for (var noteId in event.tag.notes) {
          await firebaseService.addNoteTag(event.email, noteId, event.tag.tagId);
        }

      }
    } catch (e) {

      emit(TagError(e.toString()));
      return;
    }

    emit(TagSuccess('Tag Saved Successfully!'));
  }

  Future<void> deleteTag(TagEventDeleteTag event, Emitter emit) async {
    emit(DeleteTag());

    try {
      await firebaseService.deleteTag(event.email, event.tag);

    } catch (e) {
      emit(TagError(e.toString()));
    }

    emit(TagSuccess('Tag Deleted Successfully!'));
  }

  Future<void> addNote(TagEventAddNote event, Emitter emit) async {
    emit(AddTag());

    try {
      await firebaseService.addNoteTag(event.email, event.note.noteId, event.tag.tagId);

    } catch (e) {
      emit(TagError(e.toString()));
    }

    emit(TagSuccess('Add Note Successfully!'));
  }

  Future<void> removeNote(TagEventRemoveNote event, Emitter emit) async {
    emit(RemoveTag());

    try {
      await firebaseService.deleteNoteTag(event.email, event.note.noteId, event.tag.tagId);

    } catch (e) {
      emit(TagError(e.toString()));
    }

    emit(TagSuccess('Removed Note Successfully!'));
  }


}
