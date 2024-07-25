import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:noter/bloc/note/note_bloc.dart';
import 'package:noter/bloc/user/user_bloc.dart';
import 'package:noter/models/note.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      // mainAxisAlignment: MainAxisAlignment.end,
      children: [
        BlocBuilder<NoteBloc, NoteState>(builder: (context, state) {
          UserState userState = context.read<UserBloc>().state;
          List<Note> notes = [];
          if (userState is UserCollecting) {
            return const Center(
                child: CircularProgressIndicator(
              backgroundColor: Colors.white,
            ));
          }
          if (userState is UserSuccess) {
            notes = context.read<UserBloc>().user.notes.values.toList();
          }
          if (notes.isNotEmpty) {
            return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    child: Card(
                        child: ListTile(
                      title: Text(notes[index].title),
                      subtitle: Text(
                          Document.fromJson(jsonDecode(notes[index].content))
                              .toPlainText()),
                      trailing: const Icon(Icons.chevron_right),
                    )),
                    onTap: () {
                      Navigator.pushNamed(context, '/main/note',
                          arguments: notes[index]);
                    },
                  );
                });
          } else {
            return const Center(
              child: Text(
                "You don't have any notes yet, Add one to get started!",
                style: TextStyle(
                  fontSize: 20,
                ),
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            );
          }
        }),
      ],
    );
  }
}
