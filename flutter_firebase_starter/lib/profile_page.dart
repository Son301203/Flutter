import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfliePage extends StatefulWidget {
  const ProfliePage({super.key});

  @override
  State<ProfliePage> createState() => _ProfliePageState();
}

class _ProfliePageState extends State<ProfliePage> {
  final auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proflie page'),
      ),
      body: Column(
        children: [
          Text(
            auth.currentUser?.email ?? 'N/A',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          FilledButton.tonalIcon(
            onPressed: signOut,
            icon: const Icon(Icons.logout),
            label: const Text('Sign Out'),
          )
        ],
      ),
    );
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
