import 'package:flutter/material.dart';
import 'signup.dart';
import 'login.dart';
import 'displayPosts.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(onLogin: (loggedInUserId) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => DisplayPostsScreen(loggedInUserId: loggedInUserId)),
          );
        }),
        '/signup': (context) => SignUpScreen(),
      },
    );
  }
}