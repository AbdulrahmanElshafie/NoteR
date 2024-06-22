/*
- CreateTag(tagName) # Create a new tage -> In Progress
- DeleteTag() # Delete the tag & remove it from the notes associated with it -> In Progress
- UpdateTagName(newTagName) # Update name of the tag -> In Progress
- GetTagNotes() # Get notes associated with the tag -> In Progress
- AddNewNote(noteId) # Add a new note to the associated notes list -> In Progress
- GetNumTagNotes() # Get number of notes associated with the tag -> In Progress
 */

import 'dart:math';
import 'package:noter/models/note.dart';

class Tag{
  late String name, tagId;
  late DateTime creationDate, modificationDate;
  int numNotesAssociatedWith = 0;
  List<String> associatedNote = [];

  Tag(this.name){
    tagId = Random.secure().nextInt(1000000000).toString();
    creationDate = DateTime.now();
    modificationDate = DateTime.now();
  }

  Tag.fromMap(Map<String, dynamic> map){
    name = map['name'];
    tagId = map['tagId'];
    creationDate = DateTime.fromMillisecondsSinceEpoch(map['creationDate'].seconds * 1000);
    modificationDate = DateTime.fromMillisecondsSinceEpoch(map['modificationDate'].seconds * 1000);
    for(int i = 0; i < map['associatedNote'].length; i++){
      associatedNote.add(map['associatedNote'][i]['noteId']);
      numNotesAssociatedWith++;
    }
  }

  void addNote(Note newNote){
    associatedNote.add(newNote.noteId);
    numNotesAssociatedWith++;

  }

  void removeNote(Note note){
    associatedNote.remove(note.noteId);
    numNotesAssociatedWith--;
  }

  List<String> getNotes() => associatedNote;

  void deleteTag(){
    associatedNote.clear();
    numNotesAssociatedWith = 0;
  }

  void updateTagName(String newTagName){
    name = newTagName;
  }

  int getNumTagNotes(){
    return numNotesAssociatedWith;
  }

}