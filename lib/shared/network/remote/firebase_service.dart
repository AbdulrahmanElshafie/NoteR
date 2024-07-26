import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:noter/main.dart';
import 'package:noter/models/note.dart';
import 'package:noter/models/tag.dart';
import 'package:noter/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirebaseService {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  final messaging = FirebaseMessaging.instance;

  FirebaseService() {
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Authentication
  Future<void> register(String email, String password) async {
    await auth.createUserWithEmailAndPassword(
        email: email, password: password);

  }

  Future<void> login(String email, String password) async {
    await auth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> logout() async {
    await auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    print('in reset pass in firebase');
    print(email);
    await auth.sendPasswordResetEmail(email: email.trim());
    print('after completion');
  }

  // Database

  // Creation
  Future<void> addUserToDb(
      String name,
      String email,
      String gender,
      DateTime birthday,
      String location,
      String language) async {
    await db.collection("users").doc(email).set({
      "name": name,
      "email": email,
      "gender": gender,
      "birthday": birthday,
      "location": location,
      "language": language,
    });
  }

  Future<void> addTagToDb(String email, Tag tag) async {
    await db
        .collection("users")
        .doc(email)
        .collection("tags")
        .doc(tag.tagId)
        .set({
      "name": tag.name,
      'creationDate': tag.creationDate,
      'modificationDate': tag.modificationDate
    });
  }

  Future<void> addNoteToDb(String email, Note note) async {
    await db
        .collection("users")
        .doc(email)
        .collection("notes")
        .doc(note.noteId)
        .set({
      "title": note.title,
      "content": note.content,
      "creationDate": note.creationDate,
      "modificationDate": note.modificationDate,
      'embeddings': note.embeddings
    });
  }

  Future<void> addNoteTag(String email, String noteId, String tagId) async {
    await db
        .collection("users")
        .doc(email)
        .collection("notes")
        .doc(noteId)
        .collection("tags")
        .doc(tagId)
        .set({});

    db
        .collection('users')
        .doc(email)
        .collection("tags")
        .doc(tagId)
        .collection('notes')
        .doc(noteId)
        .set({});
  }

  // Get
  Future<DocumentSnapshot<Map<String, dynamic>>> getUserInfo(
          String email) async =>
      await db.collection("users").doc(email).get();

  Future<QuerySnapshot<Map<String, dynamic>>> getNotes(String email) async =>
      await db.collection("users").doc(email).collection("notes").get();

  Future<QuerySnapshot<Map<String, dynamic>>> getTags(String email) async =>
      await db.collection("users").doc(email).collection("tags").get();

  Future<DocumentSnapshot<Map<String, dynamic>>> readNote(
          String email, String notId) async =>
      await db
          .collection('users')
          .doc(email)
          .collection('notes')
          .doc(notId)
          .get();

  Future<QuerySnapshot<Map<String, dynamic>>> getTagsForNote(
          String noteId, String email) async =>
      await db
          .collection('users')
          .doc(email)
          .collection('notes')
          .doc(noteId)
          .collection('tags')
          .get();

  Future<QuerySnapshot<Map<String, dynamic>>> getNotesForTag(
          String tagId, String email) async =>
      await db
          .collection('users')
          .doc(email)
          .collection('tags')
          .doc(tagId)
          .collection('notes')
          .get();

  // Update
  Future<void> updateUserInfo(
      String email, String name, String location, String language) async {
    await db
        .collection("users")
        .doc(email)
        .update({"name": name, "location": location, "language": language});
  }

  Future<void> updateTagDetails(String email, Tag tag) async {
    await db
        .collection("users")
        .doc(email)
        .collection("tags")
        .doc(tag.tagId)
        .set({"name": tag.name, 'modificationDate': tag.modificationDate});
  }

  Future<void> updateNoteDetails(String email, Note note) async {
    await db
        .collection("users")
        .doc(email)
        .collection("notes")
        .doc(note.noteId)
        .update({
      "title": note.title,
      "content": note.content,
      "modificationDate": note.modificationDate,
      'embeddings': note.embeddings
    });
  }

  // Delete
  Future<void> deleteUser(String email) async {
    await auth.currentUser!.delete();
    await db.collection('users').doc(email).delete();
  }

  Future<void> deleteNote(String email, Note note) async {
    var record =
        db.collection("users").doc(email).collection("notes").doc(note.noteId);

    await record.collection('tags').get().then((onValue) {
      for (var element in onValue.docs) {
        db
            .collection("users")
            .doc(email)
            .collection("tags")
            .doc(element.id)
            .collection('notes')
            .doc(note.noteId)
            .delete();
      }
    });

    await record.delete();
  }

  Future<void> deleteTag(String email, Tag tag) async {
    var record =
        db.collection("users").doc(email).collection("tags").doc(tag.tagId);

    await record.collection('notes').get().then((onValue) {
      for (var element in onValue.docs) {
        db
            .collection("users")
            .doc(email)
            .collection("notes")
            .doc(element.id)
            .collection('tags')
            .doc(tag.tagId)
            .delete();
      }
    });

    await record.delete();
  }

  Future<void> deleteNoteTag(String email, String noteId, String tagId) async {
    await db
        .collection("users")
        .doc(email)
        .collection("notes")
        .doc(noteId)
        .collection("tags")
        .doc(tagId)
        .delete();

    await db
        .collection("users")
        .doc(email)
        .collection("tags")
        .doc(tagId)
        .collection("notes")
        .doc(noteId)
        .delete();
  }

  // Notifications
  Future<String> initMessaging() async {
    await messaging.requestPermission();

    return messaging.getToken().toString();
  }

  Future<void> saveMessagingToken(String email, String token) async {
    await db
        .collection("users")
        .doc(email)
        .set({"fcmToken": token}, SetOptions(merge: true));
  }


}
