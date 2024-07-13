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
import 'package:noter/shared/network/remote/firebase_service.dart';
import 'package:page_transition/page_transition.dart';
// import 'package:splash_view/source/presentation/pages/splash_view.dart';
// import 'package:splash_view/source/presentation/widgets/done.dart';
import 'bloc/user/user_bloc.dart';
import 'moduls/setting/SettingScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // if(FirebaseAuth.instance.currentUser != null){
  //   context.read<UserBloc>().add(UserEventLoadUser(email));
  // }
  runApp(MyApp());
}

Widget loader(BuildContext context) {
  print(context.read<UserBloc>().state);
  FirebaseService firebase = context.read<UserBloc>().firebaseService;
  if (firebase.auth.currentUser == null) {
    return Loginscreen();
  } else {
    String email = firebase.auth.currentUser?.email as String;
    context.read<UserBloc>().add(UserEventLoadUser(email));
    if (context.read<UserBloc>().state is UserSuccess) {
      return const MainScreen();
    } else {
      return const Center(
          child: CircularProgressIndicator(
        backgroundColor: Colors.white,
      ));
    }
  }
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

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
            print(state);
            FirebaseService firebase = context.read<UserBloc>().firebaseService;
            if (firebase.auth.currentUser == null) {
              return Loginscreen();
            } else {
              if (state is UserInitial) {
                String email = firebase.auth.currentUser?.email as String;
                context.read<UserBloc>().add(UserEventLoadUser(email));
              }
              if (state is UserSuccess) {
                return const MainScreen();
              }
              if (state is UserCollecting) {
                return const Center(
                    child: CircularProgressIndicator(
                  backgroundColor: Colors.white,
                ));
              }
              return SizedBox.shrink();
            }
          },
        ),
        debugShowCheckedModeBanner: false,
        routes: {
          '/signup': (context) => const SignUpScreen(),
          '/login': (context) => Loginscreen(),
          '/main': (context) => const MainScreen(),
          '/main/home': (context) => const HomeScreen(),
          '/main/account': (context) => const AccountScreen(),
          '/main/note': (context) => NoteScreen(),
          '/main/categories': (context) => const CategoriesScreen(),
          '/main/tag': (context) => const TagScreen(),
          '/main/search': (context) => const SearchScreen(),
          '/main/settings': (context) => const SettingScreen(),
        },
      ),
    );
  }
}
// BlocBuilder<UserBloc, UserState>
// (
// builder: (context, state) {
// FirebaseService firebase = context.read<UserBloc>().firebaseService;
// if (firebase.auth.currentUser == null) {
// return Loginscreen();
// } else {
// String email = firebase.auth.currentUser?.email as String;
// context.read<UserBloc>().add(UserEventLoadUser(email));
// if (context.read<UserBloc>().state is UserLoading) {
// return const Center(child: CircularProgressIndicator());
// } else if (context.read<UserBloc>().state is UserError) {
// return const Center(child: Text(
// 'Something went wrong',
// )
// );
// } else {
// return const MainScreen();
// }
// }
// // return const MainScreen();
// },
// )
// BlocListener<UserBloc, UserState>(
// listener: (context, state) {
// var firebase = context.read<UserBloc>().firebaseService;
//
// if (firebase.auth.currentUser == null) {
// Navigator.pushNamedAndRemoveUntil(
// context, '/login', (route) => false);
// } else{
// String email = firebase.auth.currentUser?.email as String;
// context.read<UserBloc>().add(UserEventLoadUser(email));
// }
// if (state is UserLoggedIn) {
// Navigator.pushNamedAndRemoveUntil(
// context, '/main', (route) => false);
// }
// },
// )
