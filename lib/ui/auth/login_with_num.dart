import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ui_1/Utils/utils.dart';
import 'package:ui_1/firebase_services/singleinstance.dart';
import 'package:ui_1/ui/auth/verify_code.dart';
import 'package:ui_1/wigdets/round_button.dart';

class LoginWithPhoneNumber extends StatefulWidget {
  const LoginWithPhoneNumber({super.key});

  @override
  State<LoginWithPhoneNumber> createState() => _LoginWithPhoneNumberState();
}

class _LoginWithPhoneNumberState extends State<LoginWithPhoneNumber> {
  bool loading = false;
  final phoneNumberController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuthSingleton.getInstance();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Login          ")),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          Form(
            key: _formKey,
            child: TextFormField(
              controller: phoneNumberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Enter Phone Number'),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Enter phone number';
                } else if (value.length > 14 || value.length < 11) {
                  return 'phone must contain 11 digits';
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 80,
          ),
          RoundButton(
              title: "Login",
              loading: loading,
              onTap: () {
                if (_formKey.currentState!.validate()) {
                  _auth.verifyPhoneNumber(
                      phoneNumber: phoneNumberController.text,
                      verificationCompleted: (_) {},
                      verificationFailed: (e) {
                        setState(() {
                          loading = false;
                        });
                        Utils().toastMessage(
                            e.toString().replaceAll(RegExp('\\[.*?\\]'), ''));
                      },
                      codeSent: (String verificationId, int? token) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => VerifyCodeScreen(
                                    verificationId: verificationId)));
                        setState(() {
                          loading = false;
                        });
                      },
                      codeAutoRetrievalTimeout: (e) {
                        Utils().toastMessage(
                            e.toString().replaceAll(RegExp('\\[.*?\\]'), ''));
                        setState(() {
                          loading = false;
                        });
                      });
                }
              })
        ],
      ),
    );
  }
}
