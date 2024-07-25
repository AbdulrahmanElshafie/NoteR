import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:noter/bloc/note/note_bloc.dart';
import 'package:noter/bloc/tag/tag_bloc.dart';
import 'package:noter/bloc/user/user_bloc.dart';
import 'package:noter/models/note.dart';
import 'package:noter/models/tag.dart';
import 'package:noter/shared/components/GeminiAPI.dart';

class NoteScreen extends StatelessWidget {
  NoteScreen({super.key});
  final QuillController _controller = QuillController.basic();
  GeminiApi geminiApi = GeminiApi();

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
                  onPressed: () async {
                    note.modificationDate = DateTime.now();
                    note.content = jsonEncode(_controller.document.toDelta().toJson());
                    note.embeddings = await geminiApi.embeddingGenerator('${note.title} ${note.content}');

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
                      List<ValueItem<String>> tagsOptions = [];
                      for (var tag in context.read<UserBloc>().user.tags.values) {
                        tagsOptions.add(ValueItem(value: tag.tagId, label: tag.name));
                      }
                      List<String> selectedTags = note.tags;
                      print('selected tags init ${selectedTags}');

                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              Tag newTag = Tag('');
                              TextEditingController tagController = TextEditingController();

                              return BlocBuilder<TagBloc, TagState>(
                                builder: (context, state) {
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
                                          if(!selectedTags.contains(newTag.tagId)) {
                                            selectedTags.add(newTag.tagId);
                                            print('on add new tag & select it ${selectedTags}');
                                          }
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
                                          String tagId = option.value as String;
                                          if(!selectedTags.contains(tagId)) {
                                            selectedTags.add(tagId);
                                            print('on select new option ${selectedTags}');
                                          }
                                        }
                                      },
                                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                                      dropdownHeight: 300,
                                      searchEnabled: true,
                                      clearIcon: const Icon(Icons.clear),
                                      onOptionRemoved: (idx, item){
                                        String tagId = item.value as String;
                                        selectedTags.remove(tagId);
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
                                            print('save selected tags $selectedTags');
                                            print('save note tags ${note.tags}');

                                            Map<String, Tag> userTags = context.read<UserBloc>().user.tags;
                                            Map<String, Note> userNotes = context.read<UserBloc>().user.notes;

                                            for (var tag in selectedTags) {

                                              if(!userTags[tag]!.notes.contains(note.noteId)){
                                                // save to local
                                                userTags[tag]?.addNote(note.noteId);
                                                userNotes[note.noteId]?.addTag(tag);

                                                // save to cloud
                                                context.read<NoteBloc>().add(NoteEventAddTag(context.read<UserBloc>().user.email, note.noteId, tag));
                                              }
                                            }
                                            context.read<UserBloc>().user.tags = userTags;
                                            context.read<UserBloc>().user.notes = userNotes;

                                            userNotes.clear();
                                            userTags.clear();

                                            print('after save selected tags $selectedTags');
                                            print('after save note tags ${note.tags}');

                                            // some tags has been removed
                                            if(note.tags.length > selectedTags.length) {

                                              for(int i = 0; i < note.tags.length; i++) {

                                                if(!selectedTags.contains(note.tags[i])) {
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
                    onPressed: () async {

                      note.modificationDate = DateTime.now();
                      note.content = jsonEncode(_controller.document.toDelta().toJson());
                      note.embeddings = await geminiApi.embeddingGenerator('${note.title} ${note.content}');

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
