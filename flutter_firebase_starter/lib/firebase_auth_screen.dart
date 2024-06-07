import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'auth_gate.dart';
import 'home_page.dart';


class FirebaseAuthScreen extends StatefulWidget {
  const FirebaseAuthScreen({super.key});

  @override
  State<FirebaseAuthScreen> createState() => _FirebaseAuthScreenState();
}

class _FirebaseAuthScreenState extends State<FirebaseAuthScreen> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: LayoutBuilder(builder: (context, constraints){
          return Row(
            children: [
              Visibility(
                visible: constraints.maxWidth >= 720,
                child: Expanded(
                  child: Container(
                    height: double.infinity,
                    child: Placeholder(),
                  ),
                )
              ),
              SizedBox(
                width: constraints.maxWidth >= 720
                  ? constraints.maxWidth / 2
                  : constraints.maxWidth,
                child: StreamBuilder<User?>(
                  stream: auth.authStateChanges(),
                  builder: (context, snapshot) {
                    if(snapshot.hasData) {
                      return const HomeScreen();
                    }
                    return const AuthGate();
                  },
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}