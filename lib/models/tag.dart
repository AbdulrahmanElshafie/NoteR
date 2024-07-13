/*
- CreateTag(tagName) # Create a new tage -> In Progress
- DeleteTag() # Delete the tag & remove it from the notes associated with it -> In Progress
- UpdateTagName(newTagName) # Update name of the tag -> In Progress
- GetTagNotes() # Get notes associated with the tag -> In Progress
- AddNewNote(noteId) # Add a new note to the associated notes list -> In Progress
- GetNumTagNotes() # Get number of notes associated with the tag -> In Progress
 */

import 'dart:math';

class Tag{
  late String name, tagId;
  late DateTime creationDate, modificationDate;
  int numNotesAssociatedWith = 0;
  List<String> notes = [];

  Tag(this.name){
    tagId = Random.secure().nextInt(1000000000).toString();
    creationDate = DateTime.now();
    modificationDate = DateTime.now();
  }

  Tag.fromMap(Map<String, dynamic> map){
    name = map['name'];
    creationDate = DateTime.fromMillisecondsSinceEpoch(map['creationDate'].seconds * 1000);
    modificationDate = DateTime.fromMillisecondsSinceEpoch(map['modificationDate'].seconds * 1000);
  }

  void addNote(String noteID){
    notes.add(noteID);
    numNotesAssociatedWith++;

  }

  void removeNote(String noteID){
    notes.remove(noteID);
    numNotesAssociatedWith--;
  }

  List<String> getNotes() => notes;

  void deleteTag(){
    notes.clear();
    numNotesAssociatedWith = 0;
  }

  void updateTagName(String newTagName){
    name = newTagName;
  }

  int getNumTagNotes(){
    return numNotesAssociatedWith;
  }

}