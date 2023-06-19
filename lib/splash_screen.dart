import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tech_app/Authentication/login_screen.dart';
import 'package:tech_app/Global/global.dart';
import 'package:tech_app/main_screen.dart';
// import 'package:tech_app/Authentication/signup_screen.dart';
// import 'package:tech_app/main_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() {
    return _MySplashScreenState();
  }
}

class _MySplashScreenState extends State<MySplashScreen> {
  // Memulai Timer
  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      if (firebaseAuth.currentUser != null) {
        currentFirebaseUser = firebaseAuth.currentUser;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => const MyMainScreen(),
          ),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (c) => const MyLoginScreen(),
          ),
        );
      }
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(context) {
    return Material(
      child: Container(
        color: const Color.fromARGB(255, 56, 120, 240),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(40.0),
                child: Image.asset("assets/images/logo-splash.png"),
              ),
              const SizedBox(
                height: 40,
              ),
              // const Text(
              //   'Smart Dispatcher App',
              //   style: TextStyle(
              //       fontSize: 24,
              //       color: Color.fromARGB(255, 36, 67, 92),
              //       fontWeight: FontWeight.normal),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
