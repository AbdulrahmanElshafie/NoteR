part of 'user_bloc.dart';

@immutable
sealed class UserState {}

final class UserInitial extends UserState {}

final class UserLoading extends UserState {}
final class UserCollecting extends UserState {}

final class UserLoggedIn extends UserState {}
final class UserLoggedOut extends UserState {}

final class UserTyping extends UserState {}
final class UserTypingSuccess extends UserState {
  final List<Pair> suggestions;
  UserTypingSuccess(this.suggestions);
}
final class UserPrompting extends UserState {}
final class UserPromptResponse extends UserState {
  final String response;
  UserPromptResponse(this.response);
}

final class UserError extends UserState {
  final String error;
  UserError(this.error);
}

final class UserSuccess extends UserState{
  final String success;
  UserSuccess(this.success);
}
