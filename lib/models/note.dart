/*
- CreateNote() # Create empty note -> In Progress
- UpdateNote(title, content) # add/update title & content to/of the note -> In Progress
- DeleteNote() # delete the note -> In Progress
- GetNote() # read the note / update the note in another device -> In Progress
- AddTage(tags) # add tags to the note -> In Progress
 */

import 'package:noter/models/tag.dart';
import 'dart:math';


class Note{
  late String noteId, title, content;
  late DateTime creationDate, modificationDate;
  List<String> tags = [];


  Note(){
    noteId = Random.secure().nextInt(1000000000).toString();
    title = 'No Title';
    content = '';
    creationDate = DateTime.now();
    modificationDate = DateTime.now();
  }

  Note.fromMap(Map<String, dynamic> map){
    noteId = map['noteId'];
    title = map['title'];
    content = map['content'];
    creationDate = DateTime.fromMillisecondsSinceEpoch(map['creationDate'].seconds * 1000);
    modificationDate = DateTime.fromMillisecondsSinceEpoch(map['modificationDate'].seconds * 1000);
    for(int i = 0; i < map['tags'].length; i++){
      tags.add(map['tags'][i]['tagId']);
    }
  }

  void addTag(Tag newTag){
    tags.add(newTag.tagId);
  }

  void removeTag(Tag tag){
    tags.remove(tag.tagId);
  }

  List<String> getTags() => tags;

  void updateNote(String newTitle, String newContent){
    title = newTitle;
    content = newContent;
    modificationDate = DateTime.now();
  }

  void deleteNote(){
    tags.clear();
  }


}