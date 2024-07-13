import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:noter/moduls/categories/CategoriesScreen.dart';
import 'package:noter/moduls/home/HomeScreen.dart';
import 'package:noter/moduls/search/SearchScreen.dart';
import 'package:noter/moduls/setting/SettingScreen.dart';
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
        const HomeScreen(),
        const CategoriesScreen(),
        const Center(child: CircularProgressIndicator()),
        const SearchScreen(),
        const SettingScreen(),
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
          crntIndex = index;
          setState(() {});
          if (crntIndex == 2) {
            Navigator.pushNamed(context, '/main/note', arguments: Note());
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.sticky_note_2), label: 'All Notes'),
          BottomNavigationBarItem(
              icon: Icon(Icons.category), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Note'),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), label: 'Quick Search'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }
}
