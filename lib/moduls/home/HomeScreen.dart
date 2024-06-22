import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:noter/bloc/note/note_bloc.dart';
import 'package:noter/bloc/user/user_bloc.dart';
import 'package:noter/models/note.dart';
import 'package:noter/shared/components/navbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoteR'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.account_circle_rounded,
            size: 30,
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/home/account');
          },
        ),
      ),
      body: Stack(
        // mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BlocBuilder<NoteBloc, NoteState>(builder: (context, state) {
          List<Note> notes = context.read<UserBloc>().user.notes;
          return ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: Card(
                    child: ListTile(
                      title: Text(notes[index].title),
                      subtitle: Text(Document.fromJson(jsonDecode(notes[index].content)).toPlainText()),

                  )),
                  onTap: (){
                    Navigator.pushNamed(context, '/home/note', arguments: notes[index]);
                  },
                );
              });
                    }),
          Align(
            alignment: AlignmentDirectional.bottomEnd,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home/note', arguments: Note());
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.blue[400]),
                  shape: WidgetStateProperty.all(const CircleBorder()),
                  fixedSize: WidgetStateProperty.all(const Size(50, 50)),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                  semanticLabel: 'Add Note',
                ),
              ),
            ),
          )
        ],
      ),
      // bottomNavigationBar: NavBar(crntIndex: 0),
    );
  }
}
