import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ui_1/Utils/utils.dart';
import 'package:ui_1/firebase_services/singleinstance.dart';
import 'package:ui_1/ui/auth/login_screen.dart';
import 'package:ui_1/ui/post/add_posts.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});
  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final FirebaseAuth _auth = FirebaseAuthSingleton.getInstance();
  final ref = FirebaseDatabase.instance.ref('Posts');
  final searcFilter = TextEditingController();
  final editController = TextEditingController();

// using streambuilder we also fetch data from firebase and perform some action based on data
  // @override
  // void initState() {
  //   super.initState();
  //   ref.onValue.listen((event) {});
  // }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        SystemNavigator.pop();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          title: const Text("          Post Screen"),
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
        body: Column(children: [
          const SizedBox(
            height: 30,
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: TextFormField(
              controller: searcFilter,
              decoration: const InputDecoration(
                hintText: "Search",
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {});
              },
            ),
          ),

          // fetch data from realtime firebase using streambuilder
          // Expanded(
          //   child: StreamBuilder(
          //       stream: ref.onValue,
          //       builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          //         if (!snapshot.hasData) {
          //           return const CircularProgressIndicator();
          //         } else {
          //           Map<dynamic, dynamic> map =
          //               snapshot.data!.snapshot.value as dynamic;
          //           List<dynamic> list = [];
          //           list.clear();
          //           list = map.values.toList();
          //           print("list from frebase: $list");
          //           print("dxcfvgbhnkjml,");
          //           return ListView.builder(
          //               itemCount: snapshot.data!.snapshot.children.length,
          //               itemBuilder: (context, index) {
          //                 print("index number: $index");
          //                 return ListTile(
          //                   title: Text(list[index]["description"]),
          //                   subtitle: Text(list[index]["id"]),
          //                 );
          //               });
          //         }
          //       }),
          // ),

          // firedatabase package provide this FirebaseAnimatedList
          Expanded(
            child: FirebaseAnimatedList(
                query: ref,
                defaultChild: const Center(child: Text("Loading...")),
                itemBuilder: (context, snapshot, animation, index) {
                  final String title =
                      snapshot.child("description").value.toString();

                  debugPrint("fetch data from realtime firebase: ");
                  if (searcFilter.text.isEmpty) {
                    return ListTile(
                      title:
                          Text(snapshot.child("description").value.toString()),
                      subtitle: Text(snapshot.child("id").value.toString()),
                      trailing: PopupMenuButton(
                          icon: const Icon(
                            Icons.more_vert,
                          ),
                          itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 1,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      showMyDialog(
                                          title,
                                          snapshot
                                              .child("id")
                                              .value
                                              .toString());
                                    },
                                    leading: const Icon(Icons.edit),
                                    title: const Text("Edit"),
                                  ),
                                ),
                                PopupMenuItem(
                                  value: 2,
                                  child: ListTile(
                                    onTap: () {
                                      Navigator.pop(context);
                                      ref
                                          .child(snapshot
                                              .child("id")
                                              .value
                                              .toString())
                                          .remove();
                                    },
                                    leading: const Icon(Icons.delete),
                                    title: const Text("Delete"),
                                  ),
                                ),
                              ]),
                    );
                  } else if (title
                      .toLowerCase()
                      .contains(searcFilter.text.toLowerCase())) {
                    return ListTile(
                      title:
                          Text(snapshot.child("description").value.toString()),
                      subtitle: Text(snapshot.child("id").value.toString()),
                    );
                  } else {
                    return Container();
                  }
                }),
          ),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const AddPostScreen()));
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  // update value in firebase database

  Future<void> showMyDialog(String title, String id) async {
    editController.text = title;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Update"),
            content: SizedBox(
              child: TextField(
                controller: editController,
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    ref.child(id).update({
                      "description": editController.text.toLowerCase(),
                    }).then((value) {
                      Utils().toastMessage("Updated Successfully");
                    }).onError((error, stackTrace) {
                      Utils().toastMessage(error.toString());
                    });
                    Navigator.pop(context);
                  },
                  child: const Text("update")),
            ],
          );
        });
  }
}
