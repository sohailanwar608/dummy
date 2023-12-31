import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:ui_1/Utils/utils.dart';
import 'package:ui_1/ui/post/post_screen.dart';
import 'package:ui_1/wigdets/round_button.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  bool loading = false;
  final postController = TextEditingController();
  // node(table) in database
  final databaseRef = FirebaseDatabase.instance.ref("Posts");
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Add Post             ")),
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
                databaseRef.child(id).set({
                  "description": postController.text.toString(),
                  "id": id,
                }).then((value) {
                  Utils().toastMessage("Post Added");
                  setState(() {
                    loading = false;
                  });
                  // remove all screens from stack
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PostScreen(),
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
