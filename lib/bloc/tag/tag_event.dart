part of 'tag_bloc.dart';

@immutable
sealed class TagEvent {}

final class TagEventSaveTag extends TagEvent {
  final String email;
  final Tag tag;

  TagEventSaveTag(this.email, this.tag);
}

final class TagEventAddTag extends TagEventSaveTag{
  TagEventAddTag(super.email, super.tag);
}

final class TagEventUpdateTag extends TagEventSaveTag{
  TagEventUpdateTag(super.email, super.tag);
}


final class TagEventDeleteTag extends TagEvent {
  final String email;
  final Tag tag;

  TagEventDeleteTag(this.email, this.tag);
}

// final class TagEventGetTag extends TagEvent {
//   final String email;
//   final Tag tag;
//
//   TagEventGetTag(this.email, this.tag);
// }

final class TagEventAddNote extends TagEvent {
  final String email;
  final Note note;
  final Tag tag;

  TagEventAddNote(this.email, this.note, this.tag);
}
final class TagEventRemoveNote extends TagEvent {
  final String email;
  final Note note;
  final Tag tag;

  TagEventRemoveNote(this.email, this.note, this.tag);
}

