import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:ui_1/Utils/utils.dart';
import 'package:ui_1/firebase_services/singleinstance.dart';
import 'package:ui_1/ui/auth/login_screen.dart';
import 'package:ui_1/wigdets/round_button.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
// variables
  bool loading = false;
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
//  get instance for register user
  final FirebaseAuth _auth = FirebaseAuthSingleton.getInstance();

//  method for login
  void login() {
    _auth
        .createUserWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      print(value.toString());
      Utils().toastMessage("User Registered Successfully");
      signUp();
    }).onError((error, stackTrace) {
      Utils()
          .toastMessage(error.toString().replaceAll(RegExp('\\[.*?\\]'), ''));
      signUp();
    });
  }

// method for change loading value
  void signUp() {
    setState(() {
      loading = false;
    });
  }

  // release from memory when this screen is not visible
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("build SignUp Screen");
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
          // automaticallyImplyLeading: false,
          title: const Center(child: Text("Sign Up           "))),
      body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  decoration: const InputDecoration(
                      hintText: 'Email',
                      prefixIcon: Icon(Icons.alternate_email)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter email';
                    }
                    return null;
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                      hintText: 'Password', prefixIcon: Icon(Icons.lock_open)),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Enter password';
                    }
                    return null;
                  },
                ),
              ],
            )),
        const SizedBox(
          height: 50,
        ),
        RoundButton(
            title: 'SignUp',
            loading: loading,
            onTap: () {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  loading = true;
                });

                login();
              } else {
                print(_formKey.currentState!.validate());
              }
            }),
        const SizedBox(
          height: 30,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("Don't have an account?"),
            TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const LoginScreen())));
                },
                child: const Text('Login')),
          ],
        ),
      ]),
    );
  }
}
