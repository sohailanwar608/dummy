import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ui_1/ui/splash.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const Scaffold(
        body: SplashScreen(),
      ),
    );
  }
}










































// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: Scaffold(
//           backgroundColor: Colors.indigo,
//           body: SafeArea(
//             child: Stack(
//               alignment: Alignment.topCenter,
//               children: [
//                 Positioned(
//                   height: MediaQuery.of(context).size.height * .3,
//                   width: MediaQuery.of(context).size.width,
//                   child: menu(),
//                 ),
//                 Positioned(
//                   top: MediaQuery.of(context).size.height * .25,
//                   height: MediaQuery.of(context).size.height * .6,
//                   width: MediaQuery.of(context).size.width * .85,
//                   child: box(),
//                 ),
//               ],
//             ),
//           )),
//     );
//   }

//   Container box() {
//     return Container(
//       decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(10), color: Colors.white),
//       child: SingleChildScrollView(
//         child: Column(children: [
//           spaceBetween(35),
//           setText("WOW", Colors.green, 20),
//           spaceBetween(15),
//           setText("First Party Auth", Colors.grey, 10),
//           spaceBetween(45),
//           textField("Full Name"),
//           spaceBetween(15),
//           textField("Phone Number"),
//           spaceBetween(15),
//           textField("Email"),

//           ElevatedButton(onPressed: () 
//           {
           
//           }, child: const Text("Firebase")),
//           // get otp button
//           otpBtn(45, "Get OTP")
//         ]),
//       ),
//     );
//   }

//   Container otpBtn(double heiht, String text) {
//     return Container(
//       height: heiht,
//       width: double.infinity,
//       // ignore: prefer_const_constructors
//       decoration: BoxDecoration(
//         color: Colors.green,
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(10),
//           bottomRight: Radius.circular(10),
//         ),
//       ),

//       child: Center(
//           child: Text(
//         text,
//         style:
//             const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//       )),
//     );
//   }

//   Text setText(String text, Color setColor, double? size) {
//     return Text(
//       text,
//       style: TextStyle(
//           color: setColor, fontSize: size, fontWeight: FontWeight.bold),
//     );
//   }

//   SizedBox spaceBetween(double? higt) {
//     return SizedBox(
//       height: higt,
//     );
//   }

//   Padding textField(String hintText) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 30),
//       child: TextField(
//         keyboardType: TextInputType.name,
//         decoration: InputDecoration(labelText: hintText),
//       ),
//     );
//   }

//   Container menu() {
//     return Container(
//       color: Colors.green,
//       child: const Center(
//           child: FaIcon(
//         FontAwesomeIcons.shopify,
//         size: 80,
//         color: Colors.yellow,
//       )),
//     );
//   }
// }
