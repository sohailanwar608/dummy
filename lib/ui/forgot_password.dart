import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ui_1/Utils/utils.dart';
import 'package:ui_1/firebase_services/singleinstance.dart';
import 'package:ui_1/wigdets/round_button.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuthSingleton.getInstance();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 50,
          ),
          TextFormField(
            controller: emailController,
            decoration: const InputDecoration(hintText: 'Email'),
          ),
          const SizedBox(
            height: 40,
          ),
          RoundButton(
              title: 'Forgot',
              onTap: () {
                debugPrint(emailController.text.toString());
                _auth
                    .sendPasswordResetEmail(
                        email: emailController.text.toString())
                    .then((value) {
                  Utils().toastMessage(
                      'We have sent you email to recover password, please check email');
                }).onError((error, stackTrace) {
                  Utils().toastMessage(error.toString());
                });
              })
        ],
      ),
    );
  }
}
