import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ui_1/Utils/utils.dart';
import 'package:ui_1/firebase_services/singleinstance.dart';
import 'package:ui_1/ui/post/post_screen.dart';
import 'package:ui_1/wigdets/round_button.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({Key? key, required this.verificationId})
      : super(key: key);

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final verificationCodeController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuthSingleton.getInstance();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Verify           ")),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 80,
          ),
          TextFormField(
            controller: verificationCodeController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(hintText: '6 digit code'),
          ),
          const SizedBox(
            height: 80,
          ),
          RoundButton(
              title: "Verify",
              loading: loading,
              onTap: () async {
                setState(() {
                  loading = true;
                });

                final crendital = PhoneAuthProvider.credential(
                    verificationId: widget.verificationId,
                    smsCode: verificationCodeController.text.toString());

                debugPrint(" credentilts: $crendital");

                try {
                  await _auth.signInWithCredential(crendital);
                  debugPrint(" signin successfully");

                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PostScreen()));
                } catch (e) {
                  setState(() {
                    loading = false;
                  });

                  Utils().toastMessage(
                      e.toString().replaceAll(RegExp('\\[.*?\\]'), ''));
                }
              }),
        ],
      ),
    );
  }
}
