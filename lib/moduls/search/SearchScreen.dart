import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/user/user_bloc.dart';
import '../../models/note.dart';


class SearchScreen extends StatelessWidget {
  SearchScreen({super.key});


  @override
  Widget build(BuildContext context) {
    Map<String, Note> notes = context.read<UserBloc>().user.notes;
    return Column(
      children: [
        SizedBox(height: 10,),
        TextFormField(
          decoration: InputDecoration(
              border: const OutlineInputBorder(), labelText: 'Search'),
          onChanged: (value) async {
            if (value.isNotEmpty) {
              context.read<UserBloc>().add(UserEventTyping(value));
            } else {
              context.read<UserBloc>().add(UserEventClear());
            }
          },
        ),
        SizedBox(
          height: 30,
        ),
        BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if (state is UserTyping) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if(state is UserTypingSuccess){
              return state.suggestions.isNotEmpty
                  ? Expanded(
                  child: ListView.builder(
                      itemCount: state.suggestions.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          child: Card(
                              child: ListTile(
                                title: Text(notes[state.suggestions[index].second]!.title),
                                trailing: const Icon(Icons.chevron_right),
                              )),
                          onTap: () {
                            Navigator.pushNamed(context, '/main/note',
                                arguments: notes[state.suggestions[index].second]);
                          },
                        );
                      }))
                  : const Text(
                'No Results',
                style: TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              );
            }
            return SizedBox.shrink();
          },
        )
      ],
    );
  }
}
