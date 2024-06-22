import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noter/bloc/user/user_bloc.dart';

import '../../shared/components/btn.dart';
import '../../shared/components/textBox.dart';

class Loginscreen extends StatelessWidget {
  Loginscreen({super.key});

  final TextEditingController emailController = TextEditingController(),
      passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoteR'),
        centerTitle: true,
      ),
      body: BlocConsumer<UserBloc, UserState>(
        listener: (context, state) {
          if (state is UserError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(state.error),
            ));
          } else if (state is UserLoggedIn) {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (context) => false);
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              textBox(text: 'Email', controller: emailController),
              const SizedBox(
                height: 20,
              ),
              textBox(text: 'Password', controller: passwordController),
              const SizedBox(
                height: 20,
              ),
              btn(
                  text: 'Login',
                  onPressed: () {
                    if (emailController.text.trim().isNotEmpty &&
                        passwordController.text.trim().isNotEmpty) {
                      BlocProvider.of<UserBloc>(context).add(UserEventLogin(
                          emailController.text.trim(),
                          passwordController.text.trim()));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please fill all fields'),
                      ));
                    }
                  })
            ],
          );
        },
      ),
    );
  }
}
