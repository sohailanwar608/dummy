import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ui_1/Utils/utils.dart';
import 'package:ui_1/ui/firestore/firestore_list_screen.dart';
import 'package:ui_1/wigdets/round_button.dart';

class AddFireStoreScreen extends StatefulWidget {
  const AddFireStoreScreen({super.key});

  @override
  State<AddFireStoreScreen> createState() => _AddFireStoreScreenState();
}

class _AddFireStoreScreenState extends State<AddFireStoreScreen> {
  bool loading = false;
  final postController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection("users");
  // node(table) in database

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Add Fire_Store             ")),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(children: [
          const SizedBox(
            height: 30,
          ),
          TextFormField(
            maxLines: 4,
            controller: postController,
            decoration: const InputDecoration(
                hintText: 'What is in your mind?',
                border: OutlineInputBorder()),
          ),
          const SizedBox(
            height: 30,
          ),
          RoundButton(
              title: "Add",
              loading: loading,
              onTap: () {
                setState(() {
                  loading = true;
                });
                String id = DateTime.now().microsecondsSinceEpoch.toString();
                fireStore.doc(id).set({
                  "title": postController.text.toString(),
                  "id": id,
                }).then((value) {
                  Utils().toastMessage("Post Added");
                  setState(() {
                    loading = false;
                  });
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FireStoreScreen(),
                    ),
                    (route) =>
                        false, // This predicate removes all previous routes from the stack
                  );
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                  setState(() {
                    loading = false;
                  });
                });
              }),
        ]),
      ),
    );
  }
}
