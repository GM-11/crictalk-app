import 'package:crictalk/screens/home.dart';
import 'package:crictalk/screens/login.dart';
import 'package:crictalk/screens/newTopic.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Firebase Auth',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: StreamBuilder<User?>(
      //   stream: _auth.authStateChanges(),
      //   builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return const CircularProgressIndicator();
      //     } else if (snapshot.hasData) {
      //       return const HomeScreen();
      //     } else {
      //       return const LoginScreen();
      //     }
      //   },
      // ),
      home: const NewTopicScreen()
    );
  }
}
