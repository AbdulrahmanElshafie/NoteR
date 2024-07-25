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

import 'dart:math';
import 'package:noter/models/tag.dart';
import 'package:noter/shared/components/Pair.dart';
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

  List<Pair> calcNotesSimilarity(List<double> promptEmbedding){
    List<Pair> similarities = [];
    for(var key in notes.keys){
      double score = calcCosineSimilarity(notes[key]!.embeddings, promptEmbedding);
      similarities.add(Pair(score, key));
    }
    similarities.sort((a, b) => b.first.compareTo(a.first));
    return similarities;
  }

  List<Pair> calcSimilarities(String noteId){
    List<Pair> similarities = [];
    for(var key in notes.keys){
      if(key != noteId){
        double score = calcCosineSimilarity(notes[key]!.embeddings, notes[noteId]!.embeddings);
        similarities.add(Pair(score, key));
      }
    }
    similarities.sort((a, b) => b.first.compareTo(a.first));
    return similarities;
  }

  double calcMagnitude(List<double> vector){
    double score = 0.0;
    for(int i = 0; i < vector.length; i++){
      score += pow(vector[i], 2);
    }
    return sqrt(score);
  }

  double calcCosineSimilarity(List<double> vector1, List<double> vector2){
    double magintude1 = calcMagnitude(vector1);
    double magintude2 = calcMagnitude(vector2);
    double dotProduct = 0.0;
    for(int i = 0; i < vector1.length; i++){
      dotProduct += vector1[i] * vector2[i];
    }
    return dotProduct / (magintude1 * magintude2);
  }

}