import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bcrypt/flutter_bcrypt.dart';
import 'package:noter/models/note.dart';
import 'package:noter/models/tag.dart';
import 'package:noter/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;

  FirebaseService() {
    Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  // Authentication
  Future<String> register(String email, String password) async {
    String salt = await FlutterBcrypt.salt();
    String passwordHash =
        await FlutterBcrypt.hashPw(password: password, salt: salt);

    await auth.createUserWithEmailAndPassword(
        email: email, password: passwordHash);

    return salt;
  }

  Future<String> getSalt(String email) async {
    String salt = await db.collection('salts').doc(email).get().then((value) {
      return value.data()?['salt'];
    });
    return salt;
  }

  Future<void> login(String email, String password, String salt) async {
    String passwordHash =
        await FlutterBcrypt.hashPw(password: password, salt: salt);
    await auth.signInWithEmailAndPassword(email: email, password: passwordHash);
  }

  Future<void> logout() async {
    await auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await auth.sendPasswordResetEmail(email: email);
  }

  // Database

  // Creation
  Future<void> addUserToDb(
      String name,
      String email,
      String salt,
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

    await db.collection('salts').doc(email).set({'salt': salt});
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
      "modificationDate": note.modificationDate
    });
  }

  Future<void> addNoteTag(String email, Note note, Tag tag) async {
    await db
        .collection("users")
        .doc(email)
        .collection("notes")
        .doc(note.noteId)
        .collection("tags")
        .doc(tag.tagId)
        .set({});

    db
        .collection('users')
        .doc(email)
        .collection("tags")
        .doc(tag.tagId)
        .collection('notes')
        .doc(note.noteId)
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

  // Update
  Future<void> updateUserInfo(
      String email, String name, String location, String language) async {
    await db
        .collection("users")
        .doc(email)
        .update({"name": name, "location": location, "language": language});
  }

  Future<void> updateTagDetails(String email, Note note, Tag tag) async {
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

  Future<void> deleteNoteTag(String email, Note note, Tag tag) async {
    await db
        .collection("users")
        .doc(email)
        .collection("notes")
        .doc(note.noteId)
        .collection("tags")
        .doc(tag.tagId)
        .delete();

    await db
        .collection("users")
        .doc(email)
        .collection("tags")
        .doc(tag.tagId)
        .collection("notes")
        .doc(note.noteId)
        .delete();
  }
}