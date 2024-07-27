part of 'user_bloc.dart';

@immutable
sealed class UserEvent {}

final class UserEventLogin extends UserEvent {
  final String email, password;

  UserEventLogin(this.email, this.password);
}

final class UserEventRegister extends UserEvent {
  final String name, email, password, location, gender, language;

  final DateTime birthday;

  UserEventRegister(this.name, this.email, this.password, this.gender,
      this.birthday, this.location, this.language);
}

final class UserEventLogout extends UserEvent {
  final String email;

  UserEventLogout(this.email);
}

final class UserEventUpdate extends UserEvent {
  final String name, location, email, language;

  UserEventUpdate(this.email, this.name, this.location, this.language);
}

final class UserEventResetPassword extends UserEvent {
  final String email;

  UserEventResetPassword(this.email);
}

final class UserEventDelete extends UserEvent {
  final String email;

  UserEventDelete(this.email);
}

final class UserEventGetUserInfo extends UserEvent {
  final String email;

  UserEventGetUserInfo(this.email);
}

final class UserEventGetNotes extends UserEvent {
  final String email;

  UserEventGetNotes(this.email);
}

final class UserEventGetTags extends UserEvent {
  final String email;

  UserEventGetTags(this.email);
}

final class UserEventLoadUser extends UserEvent{
  final String email;

  UserEventLoadUser(this.email);
}

final class UserEventClear extends UserEvent {}
final class UserEventTyping extends UserEvent {
  final String txt;

  UserEventTyping(this.txt);
}

final class UserEventPrompting extends UserEvent {
  final String prompt;

  UserEventPrompting(this.prompt);
}

final class UserEventUpdateNotes extends UserEvent {}