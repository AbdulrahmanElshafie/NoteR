import 'package:flutter/material.dart';

import '../../shared/components/navbar.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoteR'),
        centerTitle: true,
      ),
      body: Text("Settings"),
      bottomNavigationBar: NavBar(crntIndex: 4,),
    );
  }
}
