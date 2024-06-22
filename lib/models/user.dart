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
  List<Note> notes = [];
  List<Tag> tags = [];


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

    if(map['notes'] != null){
      for (int i = 0; i < map['notes'].length; i++) {
        notes.add(Note.fromMap(map['notes'][i]));
      }
    }

    if(map['tags'] != null){
      for (int i = 0; i < map['tags'].length; i++) {
        tags.add(Tag.fromMap(map['tags'][i]));
      }
    }

  }

  int findNote(String noteId){
    for(int i = 0; i < notes.length; i++){
      if(noteId == notes[i].noteId){
        return i;
      }
    }
    return -1;
  }

  void addNote(Note newNote){
    int noteIdx = findNote(newNote.noteId);
    if (noteIdx == -1){
      notes.add(newNote);
    } else {
      notes[noteIdx] = newNote;
    }
  }

  int findTag(String tagId){
    for(int i = 0; i < tags.length; i++){
      if(tagId == tags[i].tagId){
        return i;
      }
    }
    return -1;
  }

  void addTag(Tag newTag){
    int tagIdx = findTag(newTag.tagId);
    if (tagIdx == -1){
      tags.add(newTag);
    } else {
      tags[tagIdx] = newTag;
    }
  }

  void deleteNote(Note note){
    notes.remove(note);
  }

  void deleteTag(Tag tag){
    tags.remove(tag);
  }

  List<Tag> getTags() => tags;

  List<Note> getNotes() => notes;

  void createUser(String name, String username, String email, String password, bool gender, DateTime birthday, String location){

  }

  void updateUser(String name, String location){

  }

  void resetPassword(){

  }

  void deleteUser(){

  }

  void getUserInfo(){

  }
}