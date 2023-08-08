import 'package:firebase_auth/firebase_auth.dart';

// single instance of firbase throughout application to reduce resouces
class FirebaseAuthSingleton {
  static FirebaseAuth? _instance;

  static FirebaseAuth getInstance() {
    _instance ??= FirebaseAuth.instance;
    return _instance!;
  }
}
