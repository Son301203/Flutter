import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum AuthMode { login, register }

extension on AuthMode {
  String get title => this == AuthMode.login ? "Login" : "Register";
}

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  var mode = AuthMode.login;
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mode.title),
      ),
      body: mode == AuthMode.register
          ? Center(
              child: Column(
                children: [
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.email_outlined),
                                label: Text('Email')),
                            validator: (value) =>
                                value != null && value.isNotEmpty
                                    ? null
                                    : 'Required',
                          ),
                          TextFormField(
                            controller: passwordController,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.security_outlined),
                                label: Text('Password')),
                            obscureText: true,
                            validator: (value) =>
                                value != null && value.isNotEmpty
                                    ? null
                                    : 'Required',
                          ),
                          FilledButton(
                            onPressed: register,
                            child: const Text('Register'),
                          )
                        ],
                      ),
                    ),
                  ),
                  const Text('You have an account?'),
                  TextButton(
                      onPressed: () {
                        setState(() {
                          mode = AuthMode.login;
                        });
                      },
                      child: const Text('Login'))
                ],
              ),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          TextFormField(
                            controller: emailController,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.email_outlined),
                                label: Text('Email')),
                            validator: (value) =>
                                value != null && value.isNotEmpty
                                    ? null
                                    : 'Required',
                          ),
                          TextFormField(
                            controller: passwordController,
                            decoration: const InputDecoration(
                                icon: Icon(Icons.password_outlined),
                                label: Text('Password')),
                            obscureText: true,
                            validator: (value) =>
                                value != null && value.isNotEmpty
                                    ? null
                                    : 'Required',
                          ),
                          FilledButton(
                              onPressed: login, child: const Text('Login')),
                        ],
                      ),
                    ),
                  ),
                  const Text('You have an account?'),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        mode = AuthMode.register;
                      });
                    },
                    child: const Text('Register'),
                  )
                ],
              ),
            ),
    );
  }

  Future<void> register() async {
    print('Perform user registration function');
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (formKey.currentState!.validate()) {
      await auth.createUserWithEmailAndPassword(
          email: email, password: password);
    }
  }

  Future<void> login() async {
    print('Perform user login function');
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    if (formKey.currentState!.validate()) {
      await auth.signInWithEmailAndPassword(email: email, password: password);
    }
  }
}
