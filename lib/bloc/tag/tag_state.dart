part of 'tag_bloc.dart';

@immutable
sealed class TagState {}

final class TagInitial extends TagState {}

final class TagLoading extends TagState {}
final class TagLoaded extends TagState {}

final class TagError extends TagState {
  final String error;
  TagError(this.error);
}
final class TagSuccess extends TagState {
  final String success;
  TagSuccess(this.success);
}

final class DeleteTag extends TagState{}
final class SavingTag extends TagState{}
// final class GetTag extends TagState{}

final class AddTag extends TagState{}
final class RemoveTag extends TagState{}

