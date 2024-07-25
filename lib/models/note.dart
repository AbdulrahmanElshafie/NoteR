/*
- CreateNote() # Create empty note -> In Progress
- UpdateNote(title, content) # add/update title & content to/of the note -> In Progress
- DeleteNote() # delete the note -> In Progress
- GetNote() # read the note / update the note in another device -> In Progress
- AddTage(tags) # add tags to the note -> In Progress
 */
import 'dart:math';


class Note{
  late String noteId, title, content;
  late DateTime creationDate, modificationDate;
  List<String> tags = [];
  List<double> embeddings = [];


  Note(){
    noteId = Random.secure().nextInt(1000000000).toString();
    title = 'No Title';
    content = '';
    creationDate = DateTime.now();
    modificationDate = DateTime.now();
  }

  Note.fromMap(Map<String, dynamic> map){
    title = map['title'];
    content = map['content'];
    creationDate = DateTime.fromMillisecondsSinceEpoch(map['creationDate'].seconds * 1000);
    modificationDate = DateTime.fromMillisecondsSinceEpoch(map['modificationDate'].seconds * 1000);
    embeddings = map['embeddings'].cast<double>();
  }

  void addTag(String tagID){
    tags.add(tagID);
  }

  void removeTag(String tagID){
    tags.remove(tagID);
  }

  List<String> getTags() => tags;

  void updateNote(String newTitle, String newContent, List<double> newEmbeddings){
    title = newTitle;
    content = newContent;
    modificationDate = DateTime.now();
    embeddings = newEmbeddings;
  }

  void deleteNote(){
    tags.clear();
  }


}