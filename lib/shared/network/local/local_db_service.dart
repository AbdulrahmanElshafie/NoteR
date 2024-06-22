import 'package:noter/models/note.dart';
import 'package:noter/models/tag.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalDbService {
  late SharedPreferences prefs;
  int email = 0,
      name = 1,
      password = 2,
      gender = 3,
      location = 4,
      birthday = 5,
      language = 6,
      noteTitle = 0,
      noteContent = 1,
      noteCreationDate = 2,
      noteModificationDate = 3,
      noteTags = 4,
      tagName = 0,
      tagCreationDate = 1,
      tagModificationDate = 2,
      tagAssociatedNote = 3;

  LocalDbService(this.prefs);

  // Database
  // Creation
  Future<void> saveUser(String email, String password, String name,
      String gender, String location, String birthday, String language) async {
    await prefs.setStringList(
        'user', [email, name, password, gender, location, birthday, language]);
  }

  Future<void> saveNote(Note note) async {
    List<String> noteDetails = [
      note.title,
      note.content,
      note.creationDate.toString(),
      note.modificationDate.toString()
    ];
    for (int i = 0; i < note.tags.length; i++) {
      noteDetails.add(note.tags[i]);
    }

    await prefs.setStringList('note', noteDetails);
  }

  Future<void> saveTag(Tag tag) async {
    List<String> tagDetails = [
      tag.name,
      tag.creationDate.toString(),
      tag.modificationDate.toString()
    ];
    for (int i = 0; i < tag.associatedNote.length; i++) {
      tagDetails.add(tag.associatedNote[i]);
    }

    await prefs.setStringList('tag', tagDetails);
  }

  Future<void> saveUpdates(String uId) async {
    if (prefs.get('updates') == null) {
      await prefs.setStringList('updates', [uId]);
    } else {
      List<String>? newUpdates = prefs.getStringList('updates')?.toList();
      newUpdates?.add(uId);
      await prefs.setStringList('updates', newUpdates!);
    }
  }

  // Get
  List<String> getUser() => prefs.getStringList('user')!;

  List<String> getNote(String noteId) => prefs.getStringList(noteId)!;

  List<String> getTag(String tagId) => prefs.getStringList(tagId)!;

  List<String> getUpdates() => prefs.getStringList('updates')!;

  // Delete
  Future<void> deleteNote(String noteId) async {
    List<String> associatedTags = [], details = prefs.getStringList(noteId)!;
    for (int i = noteTags; i < details.length; i++) {
      associatedTags.add(details[i]);
    }
    await prefs.remove(noteId);

    for (int i = 0; i < associatedTags.length; i++) {
      List<String> tagDetails = prefs.getStringList(associatedTags[i])!;
      tagDetails.remove(noteId);
      await prefs.setStringList(associatedTags[i], tagDetails);
    }
  }

  Future<void> deleteTag(String tagId) async {
    List<String> associatedNotes = [], details = prefs.getStringList(tagId)!;
    for (int i = tagAssociatedNote; i < details.length; i++) {
      associatedNotes.add(details[i]);
    }
    await prefs.remove(tagId);

    for (int i = 0; i < associatedNotes.length; i++) {
      List<String> tagDetails = prefs.getStringList(associatedNotes[i])!;
      tagDetails.remove(tagId);
      await prefs.setStringList(associatedNotes[i], tagDetails);
    }
  }

  Future<void> deleteUpdates(String uId) async {
    List<String>? newUpdates = prefs.getStringList('updates')?.toList();
    newUpdates?.remove(uId);
    await prefs.setStringList('updates', newUpdates!);
  }

  // Update
  Future<void> updateNote(String noteId, String title, String content) async {
    List<String> details = prefs.getStringList(noteId)!;
    details[noteTitle] = title;
    details[noteContent] = content;
    details[noteModificationDate] = DateTime.now().toString();
    await prefs.setStringList(noteId, details);

    saveUpdates(noteId);
  }

  Future<void> updateTag(String tagId, String name) async {
    List<String> details = prefs.getStringList(tagId)!;
    details[tagName] = name;
    details[tagModificationDate] = DateTime.now().toString();
    await prefs.setStringList(tagId, details);

    saveUpdates(tagId);
  }

  Future<void> updateUser(
      String userName, String userLanguage, String userLocation) async {
    List<String> details = prefs.getStringList('user')!;
    details[name] = userName;
    details[language] = userLanguage;
    details[location] = userLocation;
    await prefs.setStringList('user', details);

    saveUpdates('user');
  }

  Future<void> updatePassword(String newPassword) async {
    List<String> details = prefs.getStringList('user')!;
    details[password] = newPassword;
    await prefs.setStringList('user', details);

    saveUpdates('user');
  }
}
