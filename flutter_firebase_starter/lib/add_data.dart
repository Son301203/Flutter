// ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'nguoi_dung.dart';

class AddDataPage extends StatefulWidget {
  const AddDataPage({super.key});

  @override
  State<AddDataPage> createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool isBusy = false;

  Future<void> createData() async {
    setState(() {
      isBusy = true;
    });
    final nguoiDung = NguoiDung(
      name: _nameController.text,
      age: int.tryParse(_ageController.text) ?? 0,
      email: _emailController.text,
    );
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .add(nguoiDung.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Thêm dữ liệu thành công')),
      );
      _nameController.clear();
      _ageController.clear();
      _emailController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e')),
      );
    }
    setState(() {
      isBusy = false;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Firebase Demo'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: isBusy ? null : createData,
                icon: const Icon(Icons.add),
                label: isBusy
                    ? const CircularProgressIndicator()
                    : const Text('Create (Thêm dữ liệu)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
