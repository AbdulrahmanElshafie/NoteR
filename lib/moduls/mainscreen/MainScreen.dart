import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:noter/moduls/categories/CategoriesScreen.dart';
import 'package:noter/moduls/chat/ChatScreen.dart';
import 'package:noter/moduls/home/HomeScreen.dart';
import 'package:noter/moduls/search/SearchScreen.dart';
import 'package:noter/moduls/setting/SettingScreen.dart';
import '../../bloc/user/user_bloc.dart';
import '../../models/note.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int crntIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoteR'),
        centerTitle: true,
      ),
      body: <Widget>[
        HomeScreen(),
        // CategoriesScreen(),
        Center(child: CircularProgressIndicator()),
        SearchScreen(),
        ChatScreen(),
        SettingScreen(),
      ][crntIndex],
      bottomNavigationBar: SnakeNavigationBar.gradient(
        elevation: 10,
        snakeShape: SnakeShape.circle,
        snakeViewGradient: const LinearGradient(
          colors: [Colors.blue, Colors.green],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        showUnselectedLabels: true,
        unselectedLabelStyle: TextStyle(
          fontSize: 10,
        ),
        currentIndex: crntIndex,
        onTap: (index) {
          context.read<UserBloc>().add(UserEventUpdateNotes());
          crntIndex = index;
          setState(() {});
          if (crntIndex == 1) {
            Navigator.pushNamed(context, '/main/note', arguments: Note());
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.sticky_note_2),
              label: 'Notes'
          ),
          // BottomNavigationBarItem(
          //     icon: Icon(Icons.category),
          //     label: 'GroupeR'
          // ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: 'NoteR'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.search),
              label: 'SearcheR'
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'ChateR'
          ),
          BottomNavigationBarItem(
              icon: Icon(
                  Icons.settings),
              label: 'Settings'
          ),
        ],
      ),
    );
  }
}
