part of 'note_bloc.dart';

@immutable
sealed class NoteState {}

final class NoteInitial extends NoteState {}

final class NoteLoading extends NoteState {}
final class NoteLoaded extends NoteState {}

final class NoteError extends NoteState {
  final String error;
  NoteError(this.error);
}
final class NoteSuccess extends NoteState {
  final String success;
  NoteSuccess(this.success);
}

final class DeleteNote extends NoteState{}
final class SavingNote extends NoteState{}
// final class GetNote extends NoteState{}

final class AddTag extends NoteState{}
final class RemoveTag extends NoteState{}
