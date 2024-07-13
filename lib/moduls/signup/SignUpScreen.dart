import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noter/shared/components/btn.dart';
import 'package:noter/shared/components/textBox.dart';

import '../../bloc/user/user_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameController = TextEditingController(),
      emailController = TextEditingController(),
      passwordController = TextEditingController(),
      locationController = TextEditingController();

  String gender = 'Male', lang = 'English';

  late DateTime birthday;

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
            Navigator.pushNamedAndRemoveUntil(context, '/main', (context) => false);
          }
        },
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Sign Up',
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                textBox(text: 'Name', controller: nameController),
                const SizedBox(
                  height: 20,
                ),
                textBox(text: 'Email', controller: emailController),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Gender:',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    RadioMenuButton(
                        value: 'Male',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value as String;
                          });
                        },
                        child: const Text('Male')),
                    RadioMenuButton(
                        value: 'Female',
                        groupValue: gender,
                        onChanged: (value) {
                          setState(() {
                            gender = value as String;
                          });
                        },
                        child: const Text('Female')),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Language:',
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    RadioMenuButton(
                        value: 'English',
                        groupValue: lang,
                        onChanged: (value) {
                          setState(() {
                            lang = value as String;
                          });
                        },
                        child: const Text('English')),
                    RadioMenuButton(
                        value: 'Arabic',
                        groupValue: lang,
                        onChanged: (value) {
                          setState(() {
                            lang = value as String;
                          });
                        },
                        child: const Text('Arabic')),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                textBox(text: 'Location', controller: locationController),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  'Birth Date:',
                  style: TextStyle(fontSize: 18),
                ),
                CalendarDatePicker(
                    initialDate: DateTime(1930),
                    firstDate: DateTime(1930),
                    lastDate: DateTime(2025),
                    onDateChanged: (date) {
                      birthday = date;
                    }),
                const SizedBox(
                  height: 20,
                ),
                textBox(text: 'Password', controller: passwordController),
                const SizedBox(
                  height: 20,
                ),
                btn(
                    text: 'Sign Up',
                    onPressed: () {
                      if (nameController.text.trim().isNotEmpty &&
                          emailController.text.trim().isNotEmpty &&
                          passwordController.text.trim().isNotEmpty &&
                          locationController.text.trim().isNotEmpty) {
                        BlocProvider.of<UserBloc>(context).add(
                            UserEventRegister(
                                nameController.text.trim(),
                                emailController.text.trim(),
                                passwordController.text.trim(),
                                lang,
                                birthday,
                                gender,
                                locationController.text.trim()));


                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Please fill all fields'),
                        ));
                      }
                    }),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                        "Have an account? "
                    ),
                    TextButton(
                        onPressed: (){
                          Navigator.popAndPushNamed(context, '/login');
                        },
                        child: Text(
                            "Login"
                        )
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
