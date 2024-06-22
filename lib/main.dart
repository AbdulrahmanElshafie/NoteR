import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noter/bloc/note/note_bloc.dart';
import 'package:noter/bloc/tag/tag_bloc.dart';
import 'package:noter/firebase_options.dart';
import 'package:noter/models/user.dart';
import 'package:noter/moduls/account/AccountScreen.dart';
import 'package:noter/moduls/categories/CategoriesScreen.dart';
import 'package:noter/moduls/login/LoginScreen.dart';
import 'package:noter/moduls/search/SearchScreen.dart';
import 'package:noter/moduls/signlogin/SignLoginScreen.dart';
import 'package:noter/moduls/signup/SignUpScreen.dart';
import 'package:noter/moduls/home/HomeScreen.dart';
import 'package:noter/moduls/note/NoteScreen.dart';
import 'package:noter/moduls/tag/TagScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc/user/user_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  runApp(MyApp(prefs: prefs,));
}


class MyApp extends StatelessWidget {
  MyApp({super.key, required this.prefs});
  late SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserBloc(prefs)),
        BlocProvider(create: (context) => NoteBloc(prefs)),
        BlocProvider(create: (context) => TagBloc(prefs)),
      ],
      child: MaterialApp(
        title: 'NoteR',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            if(context.read<UserBloc>().firebaseService.auth.currentUser == null) {
              return const Signloginscreen();
            }  else {
              List<String> userDetails = context.read<UserBloc>().localDbService.getUser();
              context.read<UserBloc>().user = UserAccount(
                userDetails[3],
                DateTime.parse(userDetails[5]),
                userDetails[4],
                userDetails[6],
                name: userDetails[1],
                email: userDetails[0],
              );
              return const HomeScreen();
            }
          },
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/signup': (context) => const SignUpScreen(),
          '/login': (context) => Loginscreen(),
          '/home': (context) => const HomeScreen(),
          '/home/account': (context) => const AccountScreen(),
          '/home/note': (context) => NoteScreen(),
          '/home/categories': (context) => const CategoriesScreen(),
          '/home/tag': (context) => const TagScreen(),
          '/home/search': (context) => const SearchScreen(),
        },
      ),
    );
  }
}