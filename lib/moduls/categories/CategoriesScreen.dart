import 'package:flutter/material.dart';
import 'package:noter/shared/components/navbar.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoteR'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Categories'),
      ),
      bottomNavigationBar: NavBar(crntIndex: 1),
    );
  }
}
