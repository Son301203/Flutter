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
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Profile Page'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            const SizedBox(
              height: 64,
            ),
            Text(
              auth.currentUser?.email ?? 'N/A',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 12,
            ),
            FilledButton.tonalIcon(
              onPressed: signOut,
              icon: const Icon(Icons.logout),
              label: const Text('Sign Out'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
