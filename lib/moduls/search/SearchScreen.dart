import 'package:flutter/material.dart';
import 'package:noter/shared/components/navbar.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text('Search'),
      ),
      bottomNavigationBar: NavBar(crntIndex: 3),
    );
  }
}
