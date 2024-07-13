/*
- CreateUser(UserFullName, username, email, password, gender, birthday, location) # Create a new user -> In Progress
- UpdateUserInfo(UserFullName, username, email, gender, birthday, location) # Update user's data -> In Progress
- ResetPassword() # Reset user's password  -> In Progress
- DeleteUser() # Delete user account  -> In Progress
- GetUserInfo() # Get user's info
- GetNotes() # Get all user's notes -> In Progress
- GetTags() # Get all user's tags -> In Progress
- AddNewNote(newNote) # Add eew note to database and to Notes list -> Done
- AddNewTag(newTag) # Add eew tag to database and to Tags list -> Done
 */

import 'package:noter/models/tag.dart';
import 'note.dart';

class UserAccount {
  late String name, email, location, gender, language;
  late DateTime birthday;
  Map<String, Note> notes = {};
  Map<String, Tag> tags = {};


  UserAccount(
      this.gender, this.birthday, this.location, this.language,
      {required this.name, required this.email}
      );


  UserAccount.fromMap(Map<String, dynamic> map) {
    name = map['name'];
    email = map['email'];
    location = map['location'];
    gender = map['gender'];
    birthday = DateTime.fromMillisecondsSinceEpoch(map['birthday'].seconds * 1000);
    language = map['language'];
  }


  void addNote(Note newNote){
    notes[newNote.noteId] = newNote;
  }

  void addTag(Tag newTag){
    tags[newTag.tagId] = newTag;
  }

  void deleteNote(Note note){
    notes.remove(note.noteId);
  }

  void deleteTag(Tag tag){
    tags.remove(tag.tagId);
  }

  List<Tag> getTags() => tags.values.toList();

  List<Note> getNotes() => notes.values.toList();

}