import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noter/bloc/user/user_bloc.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          dynamic user = BlocProvider.of<UserBloc>(context).user;
          print("user$user");
          return Column(
            children: [
              Text('Name: ${user.name}'),
              Text('Email: ${user.email}'),
              Text('Gender: ${user.gender}'),
              Text('Birthday: ${user.birthday}'),
              Text('Location: ${user.location}'),
              Text('Language: ${user.language}'),
            ],
          );
        },
      ),
    );
  }
}
