import 'package:flutter/material.dart';

class NavBar extends StatefulWidget {
  NavBar({super.key, required this.crntIndex});
  int crntIndex;
  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override

  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.sticky_note_2),
          selectedIcon: Icon(Icons.sticky_note_2_outlined),
          label: 'All Notes',
        ),
        NavigationDestination(
          icon: Icon(Icons.category),
          selectedIcon: Icon(Icons.category_outlined),
          label: 'Categories',
        ),
        NavigationDestination(
          icon: Icon(Icons.search),
          selectedIcon: Icon(Icons.search_outlined),
          label: 'Quick Search',
        ),
        NavigationDestination(
          icon: Icon(Icons.settings),
          selectedIcon: Icon(Icons.settings_outlined),
          label: 'Settings',
        ),
      ],
      onDestinationSelected: (index) {
        widget.crntIndex = index;
        setState(() {});
        if(widget.crntIndex == 0) {
          if(ModalRoute.of(context)?.settings.name != '/home') {
            Navigator.popAndPushNamed(context, '/home');
          }
        } else if(widget.crntIndex == 1) {
          if(ModalRoute.of(context)?.settings.name == '/home') {
            Navigator.pushNamed(context, '/home/categories');
          } else {
            Navigator.popAndPushNamed(context, '/home/categories');
          }
        } else if(widget.crntIndex == 2) {
          if(ModalRoute.of(context)?.settings.name == '/home') {
            Navigator.pushNamed(context, '/home/search');
          } else {
            Navigator.popAndPushNamed(context, '/home/search');
          }
        } else if(widget.crntIndex == 3) {
          if(ModalRoute.of(context)?.settings.name == '/home') {
            Navigator.pushNamed(context, '/home/settings');
          } else {
            Navigator.popAndPushNamed(context, '/home/settings');
          }
        }
      },
      selectedIndex: widget.crntIndex,
    );
  }
}
