import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noter/bloc/user/user_bloc.dart';
import 'package:noter/models/user.dart';
import '../../models/message.dart';

class ChatScreen extends StatelessWidget {
  ChatScreen({super.key});
  final bool sender = true, bot = false;
  @override
  Widget build(BuildContext context) {
    final UserAccount user = context.read<UserBloc>().user;
    return Column(
      children: [
        BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if(state is UserPromptResponse){

              user.messages.add(
                  Message(
                      text: state.response,
                      isSender: bot
                  )
              );
            }

            return Expanded(
              child: ListView.builder(
                      itemCount: user.messages.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            BubbleNormal(
                                text: user.messages[index].text,
                                isSender: user.messages[index].isSender,
                                color: user.messages[index].isSender == sender? Colors.blue : Colors.green,
                                textStyle: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),

                            ),
                            const SizedBox(
                              height: 10,
                            )
                          ],
                        );
                      }),
            );
          },
        ),
        MessageBar(
        onSend: (text) {

          user.messages.add(
            Message(
                text: text,
                isSender: sender
            )
          );
          context.read<UserBloc>().add(UserEventPrompting(text));

        },
      )
      ],
    );
  }
}
