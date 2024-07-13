import 'dart:convert';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:noter/bloc/note/note_bloc.dart';
import 'package:noter/bloc/tag/tag_bloc.dart';
import 'package:noter/bloc/user/user_bloc.dart';
import 'package:noter/models/note.dart';
import 'package:noter/models/tag.dart';

class NoteScreen extends StatelessWidget {
  NoteScreen({super.key});
  final QuillController _controller = QuillController.basic();
  List<ValueItem<String>> tagsOptions = [];

  @override
  Widget build(BuildContext context) {
    Note note = ModalRoute.of(context)!.settings.arguments as Note;
    if(note.content.isNotEmpty) {
      _controller.document = Document.fromJson(jsonDecode(note.content));
    }

    return Scaffold(
      appBar: AppBar(
        leading: Column(
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    note.modificationDate = DateTime.now();
                    note.content = jsonEncode(_controller.document.toDelta().toJson());

                    if(context.read<UserBloc>().user.notes.containsKey(note.noteId)) {
                      context.read<NoteBloc>().add(NoteEventUpdateNote(context.read<UserBloc>().user.email, note));

                    } else{
                      context.read<UserBloc>().user.addNote(note);
                      context.read<NoteBloc>().add(NoteEventAddNote(context.read<UserBloc>().user.email, note));
                    }
                    Navigator.pop(context);
                  },
                  icon: const Icon(
                  Icons.arrow_back,
                )
                ),
                const SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: TextFormField(
                    initialValue: note.title,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                    ),
                    onChanged: (value) {
                      if(value.isEmpty) {
                        note.title = 'No Title';
                      }
                      note.title = value;
                    },
                  ),
                ),
              ],
            ),
            QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: _controller,
                multiRowsDisplay: false,
                showFontSize: false,
                showFontFamily: false,
                showQuote: false,
                showIndent: false,
                showListCheck: false,
                showListNumbers: false,
                showCenterAlignment: false,
                showInlineCode: false,
                showClipboardCopy: false,
                showClipboardCut: false,
                showClipboardPaste: false,
                showCodeBlock: false,
                showListBullets: false,
                showRightAlignment: false,
                showLeftAlignment: false,
                showSubscript: false,
                showSuperscript: false,
                showDividers: false,
                showSmallButton: true,


                customButtons: [
                  QuillToolbarCustomButtonOptions(
                    icon: Icon(
                       Icons.tag,
                      ),
                    tooltip: 'Add Tag',
                    onPressed: () {
                      tagsOptions.clear();
                      for (var tag in context.read<UserBloc>().user.tags.values) {
                        tagsOptions.add(ValueItem(value: tag.tagId, label: tag.name));
                      }
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              Tag newTag = Tag('');
                              TextEditingController tagController = TextEditingController();
                              
                              return BlocBuilder<NoteBloc, NoteState>(
                                builder: (context, state) {
                                  List<String> selectedTags = note.tags;
                                  print('selected tags init ${selectedTags}');
                                  return AlertDialog(
                                  alignment: Alignment.topCenter,
                                title: const Text('Add Tag'),
                                content: Column(
                                  children: [
                                    TextFormField(
                                      decoration: const InputDecoration(
                                        labelText: 'Tag Name',
                                      ),
                                      onChanged: (value) {
                                        newTag.name = value;
                                      },
                                      controller: tagController,
                                    ),
                                    Row(
                                      children: [
                                        TextButton(onPressed: (){
                                          // add tag locally
                                          context.read<UserBloc>().user.addTag(newTag);

                                          // add tag to cloud
                                          String email = context.read<UserBloc>().user.email;
                                          context.read<TagBloc>().add(TagEventAddTag(email, newTag));

                                          // add to selected tags
                                          selectedTags.add(newTag.tagId);

                                          // Navigator.pop(context);
                                        }, child: Text('Add new Tag')),
                                        TextButton(onPressed: (){
                                          tagController.clear();
                                          newTag.name = '';
                                        }, child: Text('Delete Tag')),
                                      ],
                                    ),
                                    MultiSelectDropDown(
                                      selectedOptions: selectedTags.map((e) => ValueItem(value: e, label: context.read<UserBloc>().user.tags[e]?.name as String)).toList(),
                                      options: tagsOptions,
                                      onOptionSelected: (List<ValueItem> selectedOptions){
                                        for(var option in selectedOptions) {
                                          Tag t = option.value;
                                          selectedTags.add(t.tagId);
                                          print('on select option ${selectedTags}');
                                        }
                                      },
                                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                                      dropdownHeight: 300,
                                      searchEnabled: true,
                                      clearIcon: const Icon(Icons.clear),
                                      onOptionRemoved: (idx, item){
                                        Tag t = item.value as Tag;
                                        selectedTags.remove(t.tagId);
                                        print('on remove option ${selectedTags}');
                                    },
                                    ),
                                    Align(
                                      alignment: Alignment.bottomCenter,
                                      child: Row(
                                        children: [
                                          TextButton(onPressed: (){
                                            tagController.clear();
                                            selectedTags = note.tags;

                                            Navigator.pop(context);
                                          }, child: const Text('Cancel')),
                                          const SizedBox(width: 10,),
                                          TextButton(onPressed: (){
                                            for (var tag in selectedTags) {
                                              // save local
                                              context.read<UserBloc>().user.tags[tag]?.addNote(note.noteId);
                                              context.read<UserBloc>().user.notes[note.noteId]?.addTag(tag);

                                              // save cloud
                                              context.read<NoteBloc>().add(NoteEventAddTag(context.read<UserBloc>().user.email, note.noteId, tag));
                                            }

                                            // some tags has been removed
                                            if(note.tags.length > selectedTags.length) {
                                              note.tags.sort();
                                              selectedTags.sort();

                                              for(int i = 0; i < note.tags.length; i++) {

                                                if(note.tags[i] != selectedTags[i]) {
                                                  // remove from cloud
                                                  context.read<NoteBloc>().add(NoteEventRemoveTag(context.read<UserBloc>().user.email, note.noteId, note.tags[i]));

                                                  // remove from local
                                                  context.read<UserBloc>().user.tags[note.tags[i]]?.removeNote(note.noteId);
                                                  context.read<UserBloc>().user.notes[note.noteId]?.removeTag(note.tags[i]);
                                                }
                                              }
                                            }

                                            Navigator.pop(context);
                                          }, child: const Text('Save')),
                                        ]
                                      ),
                                    )
                                  ],
                                ),
                              );
  },
);
                            }
                        );
                    },
                  ),
                  QuillToolbarCustomButtonOptions(
                    icon: const Icon(Icons.save),
                    tooltip: 'Save',
                    onPressed: () {

                      note.modificationDate = DateTime.now();
                      note.content = jsonEncode(_controller.document.toDelta().toJson());

                      if(context.read<UserBloc>().user.notes.containsKey(note.noteId)) {
                        context.read<NoteBloc>().add(NoteEventUpdateNote(context.read<UserBloc>().user.email, note));

                      } else{
                        context.read<UserBloc>().user.addNote(note);
                        context.read<NoteBloc>().add(NoteEventAddNote(context.read<UserBloc>().user.email, note));
                      }

                    },
                  ),
                  QuillToolbarCustomButtonOptions(
                    icon: const Icon(Icons.delete),
                    tooltip: 'Delete',
                    onPressed: () {
                      context.read<UserBloc>().user.deleteNote(note);
                      context.read<NoteBloc>().add(NoteEventDeleteNote(context.read<UserBloc>().user.email, note));
                      Navigator.pop(context);
                    },
                  ),

                ],
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('de'),
                ),
              ),
            ),
            QuillToolbar.simple(
              configurations: QuillSimpleToolbarConfigurations(
                controller: _controller,
                showAlignmentButtons: true,
                showDirection: true,
                multiRowsDisplay: false,
                showBoldButton: false,
                showItalicButton: false,
                showUnderLineButton: false,
                showStrikeThrough: false,
                showSearchButton: false,
                showInlineCode: false,
                showClipboardCopy: false,
                showClipboardPaste: false,
                showClipboardCut: false,
                showClearFormat: false,
                showLink: false,
                showUndo: false,
                showRedo: false,
                showHeaderStyle: false,
                showDividers: false,
                showBackgroundColorButton: false,
                showColorButton: false,

                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('de'),
                ),
              ),
            ),
          ],
        ),
        centerTitle: true,
        toolbarHeight: 140,
        leadingWidth: double.infinity,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            QuillEditor.basic(
              configurations: QuillEditorConfigurations(
                controller: _controller,
                padding: const EdgeInsets.all(15),
                scrollBottomInset: 10,
                placeholder: "What's on your mind?",
                sharedConfigurations: const QuillSharedConfigurations(
                  locale: Locale('de'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
