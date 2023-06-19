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
              Padding(
                padding: const EdgeInsets.all(30),
                child: Image.asset("assets/images/dispatch.png"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Login to your Account',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontFamily: "PTSans"),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  controller: emailTextEditingController,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 51, 44, 44),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'Email',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 56, 120, 240),
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  controller: passwordTextEditingController,
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 51, 44, 44),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Password',
                    hintText: 'Password',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 56, 120, 240),
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 12,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.grey[500],
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: ElevatedButton(
                  onPressed: () {
                    validateForm();
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 56, 120, 240),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'Sign In',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            fontFamily: "PTSans"),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              TextButton(
                child: Row(
                  children: [
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        "Don't have an Account? Register Here",
                        style: TextStyle(
                            color: Colors.grey[600], fontFamily: "PTSans"),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        thickness: 0.5,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
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
