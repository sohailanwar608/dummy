import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ui_1/Utils/utils.dart';
import 'package:ui_1/firebase_services/singleinstance.dart';
import 'package:ui_1/ui/auth/login_screen.dart';
import 'package:ui_1/wigdets/round_button.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class UploadImageScreen extends StatefulWidget {
  const UploadImageScreen({super.key});

  @override
  State<UploadImageScreen> createState() => _UploadImageScreenState();
}

class _UploadImageScreenState extends State<UploadImageScreen> {
  final FirebaseAuth _auth = FirebaseAuthSingleton.getInstance();
  bool loading = false;
  File? _image;
  final picker = ImagePicker();

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  DatabaseReference databaseRef = FirebaseDatabase.instance.ref('Post');

// for image pick from gallary
  Future getImageGallery() async {
    final pickedFile =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Utils().toastMessage("no image picked");
      }
    });
  }

  @override
  Widget build(BuildContext context) 
  {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text("Upload Image Screen"),
          actions: [
            IconButton(
                onPressed: () {
                  _auth.signOut().then((value) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()));
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(
                        error.toString().replaceAll(RegExp('\\[.*?\\]'), ''));
                  });
                },
                icon: const Icon(Icons.logout_rounded))
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: InkWell(
                onTap: () {
                  getImageGallery();
                },
                child: Container(
                  height: 200,
                  width: 200,
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: _image != null
                      ? Image.file(_image!.absolute)
                      : const Center(child: Icon(Icons.image)),
                ),
              ),
            ),
            const SizedBox(
              height: 39,
            ),
            RoundButton(
                title: "Upload",
                loading: loading,
                onTap: () async {
                  setState(() {
                    loading = true;
                  });

                  firebase_storage.Reference ref =
                      firebase_storage.FirebaseStorage.instance.ref(
                          '/sohailanwar/${DateTime.now().millisecondsSinceEpoch}');

                  firebase_storage.UploadTask uploadTask =
                      ref.putFile(_image!.absolute);

                  Future.value(uploadTask).then((value) async {
                    var newUrl = await ref.getDownloadURL();
                    //  uplpad path of image in realtime firebase
                    databaseRef
                        .child('1')
                        .set({'id': '1212', 'title': newUrl.toString()}).then(
                            (value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage('uploaded');
                    }).onError((error, stackTrace) {
                      print(error.toString());
                      setState(() {
                        loading = false;
                      });
                    });
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                    setState(() {
                      loading = false;
                    });
                  });
                }),
          ],
        ));
  }
}
