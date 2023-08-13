import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ui_1/firebase_services/singleinstance.dart';
import 'package:ui_1/ui/auth/login_screen.dart';
import 'package:ui_1/ui/firestore/firestore_list_screen.dart';
import 'package:ui_1/ui/post/post_screen.dart';
import 'package:ui_1/ui/post/upload_image.dart';

class SplashServices {
  void isLogin(BuildContext context) {
    final FirebaseAuth auth = FirebaseAuthSingleton.getInstance();
    final user = auth.currentUser;
    if (user == null) {
      Timer(
          const Duration(seconds: 3),
          () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const LoginScreen())));
    } else {
      // Timer(
      //     const Duration(seconds: 3),
      //     () => Navigator.pushAndRemoveUntil(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => const PostScreen(),
      //           ),
      //           (route) =>
      //               false, // This predicate removes all previous routes from the stack
      //         ));

      // Timer(
      //     const Duration(seconds: 3),
      //     () => Navigator.pushAndRemoveUntil(
      //           context,
      //           MaterialPageRoute(
      //             builder: (context) => const FireStoreScreen(),
      //           ),
      //           (route) =>
      //               false, // This predicate removes all previous routes from the stack
      //         ));

      Timer(
          const Duration(seconds: 3),
          () => Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => const UploadImageScreen(),
                ),
                (route) =>
                    false, // This predicate removes all previous routes from the stack
              ));
    }
  }
}
