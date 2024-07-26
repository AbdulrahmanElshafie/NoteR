import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:noter/bloc/note/note_bloc.dart';
import 'package:noter/bloc/tag/tag_bloc.dart';
import 'package:noter/firebase_options.dart';
import 'package:noter/moduls/account/AccountScreen.dart';
import 'package:noter/moduls/categories/CategoriesScreen.dart';
import 'package:noter/moduls/login/LoginScreen.dart';
import 'package:noter/moduls/search/SearchScreen.dart';
import 'package:noter/moduls/signup/SignUpScreen.dart';
import 'package:noter/moduls/home/HomeScreen.dart';
import 'package:noter/moduls/note/NoteScreen.dart';
import 'package:noter/moduls/tag/TagScreen.dart';
import 'package:noter/moduls/mainscreen/MainScreen.dart';
import 'package:noter/shared/components/constants.dart';
import 'package:noter/shared/network/remote/firebase_service.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:splash_view/source/presentation/pages/splash_view.dart';
// import 'package:splash_view/source/presentation/widgets/done.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'bloc/user/user_bloc.dart';
import 'moduls/setting/SettingScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Gemini.init(apiKey: GEMINI_API);
  // FirebaseService firebaseService = FirebaseService();
  // firebaseService.initMessaging();
  runApp(const MyApp());

}

Widget start() {
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  if (firebaseAuth.currentUser == null) {
    return Loginscreen();
  } else {
    return const MainScreen();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserBloc()),
        BlocProvider(create: (context) => NoteBloc()),
        BlocProvider(create: (context) => TagBloc()),
      ],
      child: MaterialApp(
        title: 'NoteR',
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
            pageTransitionsTheme: PageTransitionsTheme(
              builders: {
                TargetPlatform.android: PageTransition(
                  type: PageTransitionType.fade,
                  child: this,
                ).matchingBuilder,
                TargetPlatform.iOS: PageTransition(
                  type: PageTransitionType.fade,
                  child: this,
                ).matchingBuilder,
              },
            )),
        home: BlocBuilder<UserBloc, UserState>(
          builder: (context, state) {
            FirebaseService firebase = context.read<UserBloc>().firebaseService;
            if (firebase.auth.currentUser == null) {
              return Loginscreen();
            } else {
              if (state is UserInitial) {
                String email = firebase.auth.currentUser?.email as String;
                context.read<UserBloc>().add(UserEventLoadUser(email));
              }
              return MainScreen();
            }
          },
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/signup': (context) =>  SignUpScreen(),
          '/login': (context) => Loginscreen(),
          '/main': (context) =>  MainScreen(),
          '/main/home': (context) =>  HomeScreen(),
          '/main/account': (context) =>  AccountScreen(),
          '/main/note': (context) => NoteScreen(),
          '/main/categories': (context) =>  CategoriesScreen(),
          '/main/tag': (context) =>  TagScreen(),
          '/main/search': (context) => SearchScreen(),
          '/main/settings': (context) =>  SettingScreen(),
        },
      ),
    );
  }
}
