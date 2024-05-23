// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class PhotoGallaryScreen extends StatefulWidget {
  const PhotoGallaryScreen({super.key});

  @override
  State<PhotoGallaryScreen> createState() => _PhotoGallaryScreenState();
}

class _PhotoGallaryScreenState extends State<PhotoGallaryScreen> {
  final uploadedImages = <String>[];
  bool  isLoading = true;
  double uploadProgress = 0.0;

  @override

  void initState(){
    super.initState();
    loadImages();
  }

  Future loadImages() async{
    final urls = <String>[];
    try {
      final result = await FirebaseStorage.instance.ref('images').listAll();
      for (var ref in result.items) {
        final url = await ref.getDownloadURL();
        urls.add(url);
      }
      setState(() {
        uploadedImages.addAll(urls);
        isLoading = false;
      });
    }
    catch (e){
      debugPrint(e.toString());
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Photo Gallary'),
        actions:[
          IconButton(
            onPressed: pickAndUploadImage,
            icon: const Icon(Icons.add_a_photo_outlined),
          )
        ]
      ),
      body: Stack(
        children: [
          isLoading 
            ? const Center(child: CircularProgressIndicator(),)
            : GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 4.0,
                mainAxisSpacing: 4.0,
              ),
              itemCount: uploadedImages.length, 
              itemBuilder: (context, index){
                final src = uploadedImages.elementAt(index);
                return Image.network(src);
              }
            ),
            if(uploadProgress > 0.0) 
              LinearProgressIndicator(
                value: uploadProgress
              )
        ],
      )
    );
  }

  Future pickAndUploadImage() async{
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if(image != null){
      final ref = FirebaseStorage.instance.ref('images').child(image.name);
      if(kIsWeb){
        final imageData = await image.readAsBytes();
        await ref.putData(imageData);
      }
      else{
        final imageFile = File(image.path);
        final uploadTask = ref.putFile(imageFile);
        uploadTask.snapshotEvents.listen((event) {
          setState(() {
            uploadProgress = event.bytesTransferred / event.totalBytes;
          });
        });
      }
      String downloadURL = await ref.getDownloadURL();
      setState(() {
        uploadedImages.add(downloadURL);
      },);
      
    }
  }
  

}