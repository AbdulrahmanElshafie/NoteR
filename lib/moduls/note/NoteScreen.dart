import 'dart:convert';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:multi_dropdown/multiselect_dropdown.dart';
import 'package:noter/bloc/note/note_bloc.dart';
import 'package:noter/bloc/user/user_bloc.dart';
import 'package:noter/models/note.dart';
import 'package:noter/models/tag.dart';

class NoteScreen extends StatelessWidget {
  NoteScreen({super.key});
  final QuillController _controller = QuillController.basic();
  List<ValueItem<Tag>> tagsOptions = [];

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
                    context.read<UserBloc>().user.addNote(note);
                    context.read<NoteBloc>().add(NoteEventSaveNote(context.read<UserBloc>().user.email, note));
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
                      for(int i = 0; i < context.read<UserBloc>().user.tags.length; i++) {
                        Tag t = context.read<UserBloc>().user.tags[i];
                        tagsOptions.add(ValueItem(value: t, label: t.name));

                      }
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              Tag newTag = Tag('');
                              TextEditingController tagController = TextEditingController();
                              
                              return BlocBuilder<NoteBloc, NoteState>(
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
                                          context.read<UserBloc>().firebaseService.addTagToDb(context.read<UserBloc>().user.email, newTag);
                                          context.read<NoteBloc>().add(NoteEventAddTag(context.read<UserBloc>().user.email, note, newTag));
                                          context.read<UserBloc>().user.addTag(newTag);
                                          Navigator.pop(context);
                                        }, child: Text('Add new Tag')),
                                        TextButton(onPressed: (){
                                          tagController.clear();
                                          newTag.name = '';
                                        }, child: Text('Delete Tag')),
                                      ],
                                    ),
                                    MultiSelectDropDown(
                                      options: tagsOptions,
                                      onOptionSelected: (List<ValueItem> selectedOptions){
                                        for(var option in selectedOptions) {
                                          Tag t = option.value;
                                          context.read<NoteBloc>().add(NoteEventAddTag(context.read<UserBloc>().user.email, note, t));
                                        }
                                      },
                                      chipConfig: const ChipConfig(wrapType: WrapType.wrap),
                                      dropdownHeight: 300,
                                      searchEnabled: true,
                                      clearIcon: Icon(Icons.clear),
                                    
                                    ),
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
                      context.read<UserBloc>().user.addNote(note);
                      note.modificationDate = DateTime.now();
                      note.content = jsonEncode(_controller.document.toDelta().toJson());
                      context.read<NoteBloc>().add(NoteEventSaveNote(context.read<UserBloc>().user.email, note));
                      print(context.read<UserBloc>().user.notes);
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
