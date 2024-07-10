import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';

import '../../models/note.dart';

class NavBar extends StatefulWidget {
  NavBar({super.key, required this.crntIndex});
  int crntIndex;
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override

  Widget build(BuildContext context) {
    return SnakeNavigationBar.gradient(
      elevation: 10,
      snakeShape: SnakeShape.circle,
      snakeViewGradient: const LinearGradient(
        colors: [Colors.blue, Colors.green],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      // selectedItemColor: Colors.white,
      // unselectedItemColor: Colors.white,
      currentIndex: widget.crntIndex,
      onTap: (index) {



        widget.crntIndex = index;
        print(index);
        if(index == 0) {
          if(ModalRoute.of(context)?.settings.name != '/home') {
            Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
          }
        } else if(index == 1) {
          if(ModalRoute.of(context)?.settings.name == '/home') {
            Navigator.pushNamed(context, '/home/categories');
          } else if(ModalRoute.of(context)?.settings.name != '/home/categoriese') {
            Navigator.pushNamedAndRemoveUntil(context, '/home/categories', (route) => false);
          }
        } else if(index == 2) {
          if(ModalRoute.of(context)?.settings.name == '/home') {
            Navigator.pushNamed(context, '/home/note', arguments: Note());
          } else if(ModalRoute.of(context)?.settings.name != '/home/note') {
            Navigator.pushNamedAndRemoveUntil(context, '/home/note', arguments: Note(), (route) => false);
          }
        } else if(index == 3) {
          if (ModalRoute.of(context)?.settings.name == '/home') {
            Navigator.pushNamed(context, '/home/search');
          } else if(ModalRoute.of(context)?.settings.name != '/home/search') {
            Navigator.pushNamedAndRemoveUntil(context, '/home/search', (route) => false);
          }
        } else if(index == 4) {
          if (ModalRoute.of(context)?.settings.name == '/home') {
            Navigator.pushNamed(context, '/home/settings');
          } else if(ModalRoute.of(context)?.settings.name != '/home/settings') {
            Navigator.pushNamedAndRemoveUntil(context, '/home/settings', (route) => false);
          }
        }

        setState(() {});

      },
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.sticky_note_2), label: 'All Notes'),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: 'Categories'),
        BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Note'),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Quick Search'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),

      ],
    );
    // return NavigationBar(
    //   destinations: const [
    //     NavigationDestination(
    //       icon: Icon(Icons.sticky_note_2),
    //       selectedIcon: Icon(Icons.sticky_note_2_outlined),
    //       label: 'All Notes',
    //     ),
    //     NavigationDestination(
    //       icon: Icon(Icons.category),
    //       selectedIcon: Icon(Icons.category_outlined),
    //       label: 'Categories',
    //     ),
    //     NavigationDestination(
    //       icon: Icon(Icons.search),
    //       selectedIcon: Icon(Icons.search_outlined),
    //       label: 'Quick Search',
    //     ),
    //     NavigationDestination(
    //       icon: Icon(Icons.settings),
    //       selectedIcon: Icon(Icons.settings_outlined),
    //       label: 'Settings',
    //     ),
    //   ],
    //   onDestinationSelected: (index) {
    //     widget.crntIndex = index;
    //     setState(() {});
    //     if(widget.crntIndex == 0) {
    //       if(ModalRoute.of(context)?.settings.name != '/home') {
    //         Navigator.popAndPushNamed(context, '/home');
    //       }
    //     } else if(widget.crntIndex == 1) {
    //       if(ModalRoute.of(context)?.settings.name == '/home') {
    //         Navigator.pushNamed(context, '/home/categories');
    //       } else {
    //         Navigator.popAndPushNamed(context, '/home/categories');
    //       }
    //     } else if(widget.crntIndex == 2) {
    //       if(ModalRoute.of(context)?.settings.name == '/home') {
    //         Navigator.pushNamed(context, '/home/search');
    //       } else {
    //         Navigator.popAndPushNamed(context, '/home/search');
    //       }
    //     } else if(widget.crntIndex == 3) {
    //       if(ModalRoute.of(context)?.settings.name == '/home') {
    //         Navigator.pushNamed(context, '/home/settings');
    //       } else {
    //         Navigator.popAndPushNamed(context, '/home/settings');
    //       }
    //     }
    //   },
    //   selectedIndex: widget.crntIndex,
    // );
  }
}
