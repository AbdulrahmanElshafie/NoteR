part of 'note_bloc.dart';

@immutable
sealed class NoteEvent {}

final class NoteEventSaveNote extends NoteEvent {
  final String email;
  final Note note;

  NoteEventSaveNote(this.email, this.note);
}

final class NoteEventAddNote extends NoteEventSaveNote{
  NoteEventAddNote(super.email, super.note);
}

final class NoteEventUpdateNote extends NoteEventSaveNote{
  NoteEventUpdateNote(super.email, super.note);
}


final class NoteEventDeleteNote extends NoteEvent {
  final String email;
  final Note note;

  NoteEventDeleteNote(this.email, this.note);
}

// final class NoteEventGetNote extends NoteEvent {
//   final String email;
//   final Note note;
//
//   NoteEventGetNote(this.email, this.note);
// }

final class NoteEventAddTag extends NoteEvent {
  final String email;
  final String noteId;
  final String tagId;

  NoteEventAddTag(this.email, this.noteId, this.tagId);
}
final class NoteEventRemoveTag extends NoteEvent {
  final String email;
  final String noteId;
  final String tagId;


  NoteEventRemoveTag(this.email, this.noteId, this.tagId);
}

