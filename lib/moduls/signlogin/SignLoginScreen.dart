import 'package:flutter/material.dart';
import 'package:noter/shared/components/btn.dart';

class Signloginscreen extends StatelessWidget {
  const Signloginscreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NoteR'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            btn(
                text: 'Sign Up',
                onPressed: (){
                    Navigator.pushNamed(context, '/signup');
                }),
            const SizedBox(
              height: 20,
            ),
            btn(
                text: 'Sign In',
                onPressed: (){
                  Navigator.pushNamed(context, '/login');
                }),
          ],
        ),
      ),
    );
  }
}
