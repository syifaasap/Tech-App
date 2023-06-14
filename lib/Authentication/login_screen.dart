import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tech_app/Authentication/signup_screen.dart';
import 'package:tech_app/splash_screen.dart';

import '../Global/global.dart';
import '../Widgets/progress_dialog.dart';

class MyLoginScreen extends StatefulWidget {
  const MyLoginScreen({super.key});

  @override
  State<MyLoginScreen> createState() {
    return _MyLoginScreenState();
  }
}

class _MyLoginScreenState extends State<MyLoginScreen> {
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if (!emailTextEditingController.text.contains("@")) {
      return Fluttertoast.showToast(msg: "Invalid email address");
    } else if (passwordTextEditingController.text.isEmpty) {
      return Fluttertoast.showToast(
          msg: "Password must be atleast 6 characters");
    } else {
      loginTechnicianNow();
    }
  }

  loginTechnicianNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return MyProgressDialog(message: 'Processing, Please wait...');
        });

    final User? firebaseUser = (await firebaseAuth
            .signInWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Error: $msg');
    }))
        .user;

    if (firebaseUser != null) {
      DatabaseReference techiniciansRef =
          FirebaseDatabase.instance.ref().child("technicians");
      techiniciansRef.child(firebaseUser.uid).once().then((technicianKey) {
        final snap = technicianKey.snapshot;
        if (snap.value != null) {
          currentFirebaseUser = firebaseUser;
          Fluttertoast.showToast(msg: 'Login Succesful!');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => const MySplashScreen()),
          );
        } else {
          firebaseAuth.signOut();
          Fluttertoast.showToast(msg: 'Email does not exist');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (c) => const MySplashScreen()),
          );
        }
      });
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Error occured, please try again.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(50),
                child: Image.asset('assets/images/login.png'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Login as Technician',
                style: TextStyle(
                  fontSize: 28,
                  color: Color.fromARGB(255, 72, 147, 137),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30.0),
                child: TextField(
                  controller: emailTextEditingController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 51, 44, 44),
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Email',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(136, 158, 158, 158),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(136, 158, 158, 158),
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: passwordTextEditingController,
                keyboardType: TextInputType.text,
                obscureText: true,
                style: const TextStyle(
                  color: Color.fromARGB(255, 51, 44, 44),
                ),
                decoration: const InputDecoration(
                  labelText: 'Password',
                  hintText: 'Password',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(136, 158, 158, 158),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(136, 158, 158, 158)),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  validateForm();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 72, 147, 137),
                ),
                child: const Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
              TextButton(
                child: const Text(
                  "Don't have an Account? Register Here",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (c) => const MySignUpScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
