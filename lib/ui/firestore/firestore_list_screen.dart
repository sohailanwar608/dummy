import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/services.dart';
import 'package:ui_1/Utils/utils.dart';
import 'package:ui_1/firebase_services/singleinstance.dart';
import 'package:ui_1/ui/auth/login_screen.dart';
import 'package:ui_1/ui/firestore/add_firestore_data.dart';
import 'package:ui_1/ui/post/add_posts.dart';

class FireStoreScreen extends StatefulWidget {
  const FireStoreScreen({super.key});

  @override
  State<FireStoreScreen> createState() => _FireStoreScreenState();
}

class _FireStoreScreenState extends State<FireStoreScreen> {
  final FirebaseAuth _auth = FirebaseAuthSingleton.getInstance();

  final searcFilter = TextEditingController();
  final editController = TextEditingController();
  final fireStore = FirebaseFirestore.instance.collection('users').snapshots();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

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
          title: const Text("Fire Store"),
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

          // firedatabase package provide this StreamBuilder
          StreamBuilder<QuerySnapshot>(
              stream: fireStore,
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                debugPrint("Data added in Firestore database");
                if (snapshot.hasError) {
                  return const Text('Something went wrong');
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Text("Loading");
                } else {
                  return Expanded(
                    child: ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title:
                                Text(snapshot.data!.docs[index].id.toString()),
                            subtitle: Text(
                                snapshot.data!.docs[index]['title'].toString()),
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
                                                snapshot
                                                    .data!.docs[index]['title']
                                                    .toString(),
                                                snapshot.data!.docs[index].id
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
                                            users
                                                .doc(snapshot
                                                    .data!.docs[index].id
                                                    .toString())
                                                .delete()
                                                .then((value) {
                                              Utils()
                                                  .toastMessage("Data Deleted");
                                            }).onError((error, stackTrace) {
                                              Utils().toastMessage(
                                                  error.toString());
                                            });
                                          },
                                          leading: const Icon(Icons.delete),
                                          title: const Text("Delete"),
                                        ),
                                      ),
                                    ]),
                          );
                        }),
                  );
                }
              }),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const AddFireStoreScreen()));
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
                    users.doc(id).update({
                      "title": editController.text.toLowerCase(),
                    }).then((value) {
                      Utils().toastMessage("Dtat Updated");
                    }).catchError((error) {
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
