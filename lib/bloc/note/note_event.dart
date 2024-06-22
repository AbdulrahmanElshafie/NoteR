part of 'note_bloc.dart';

@immutable
sealed class NoteEvent {}

final class NoteEventDeleteNote extends NoteEvent {
  final String email;
  final Note note;

  NoteEventDeleteNote(this.email, this.note);
}
final class NoteEventUpdateNote extends NoteEvent {
  final String email;
  final Note note;

  NoteEventUpdateNote(this.email, this.note);
}
final class NoteEventGetNote extends NoteEvent {
  final String email;
  final Note note;

  NoteEventGetNote(this.email, this.note);
}

final class NoteEventAddTag extends NoteEvent {
  final String email;
  final Note note;
  final Tag tag;

  NoteEventAddTag(this.email, this.note, this.tag);
}
final class NoteEventRemoveTag extends NoteEvent {
  final String email;
  final Note note;
  final Tag tag;

  NoteEventRemoveTag(this.email, this.note, this.tag);
}

final class NoteEventSaveNote extends NoteEvent {
  final String email;
  final Note note;

  NoteEventSaveNote(this.email, this.note);
}