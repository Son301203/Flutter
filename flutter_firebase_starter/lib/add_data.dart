import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'furniture.dart';

class AddDataPage extends StatefulWidget {
  const AddDataPage({super.key});

  @override
  State<AddDataPage> createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String imageURL = '';
  File? _imageFile;

  bool isBusy = false;

  Future<void> createData() async {
    setState(() {
      isBusy = true;
    });
    final furniture = Furniture(
      name: _nameController.text,
      price: int.tryParse(_priceController.text) ?? 0,
      description: _descriptionController.text,
      image: imageURL,
    );
    try {
      await FirebaseFirestore.instance
          .collection('Furnitures')
          .add(furniture.toMap());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Add data successfully')),
      );
      _nameController.clear();
      _priceController.clear();
      _descriptionController.clear();
      setState(() {
        _imageFile = null;
        imageURL = '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
    setState(() {
      isBusy = false;
    });
  }
  
  Future<void> pickImage() async {
    ImagePicker imagePicker = ImagePicker();
    XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
    if (file == null) return;

    setState(() {
      _imageFile = File(file.path);
    });

    String uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();

    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('images');
    Reference referenceImageToUpload = referenceDirImages.child(uniqueFileName);

    try {
      await referenceImageToUpload.putFile(_imageFile!);
      imageURL = await referenceImageToUpload.getDownloadURL();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: const Text('Add Furnitures'),
        centerTitle: true,
      ),
      resizeToAvoidBottomInset: false,
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
                controller: _priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
              ),
              const SizedBox(height: 20),
              _imageFile == null
                  ? const Icon(Icons.image, size: 100)
                  : Image.file(
                      _imageFile!,
                      width: 100,
                      height: 100,
                    ),
              const SizedBox(height: 20),
              IconButton(
                onPressed: pickImage,
                icon: const Icon(Icons.add_a_photo_outlined),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: isBusy ? null : createData,
                icon: const Icon(Icons.add),
                label: isBusy
                    ? const CircularProgressIndicator()
                    : const Text('Add Furniture'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
