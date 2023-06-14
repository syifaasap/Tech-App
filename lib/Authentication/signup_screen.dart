import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tech_app/Authentication/login_screen.dart';
import 'package:tech_app/Authentication/vehicle_info_screen.dart';
import 'package:tech_app/Global/global.dart';
import 'package:tech_app/Widgets/progress_dialog.dart';
// import 'package:tech_app/Authentication/vehicle_info_screen.dart';

class MySignUpScreen extends StatefulWidget {
  const MySignUpScreen({super.key});

  @override
  State<MySignUpScreen> createState() {
    return _MySignUpScreenState();
  }
}

class _MySignUpScreenState extends State<MySignUpScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

  validateForm() {
    if (nameTextEditingController.text.length < 5) {
      return Fluttertoast.showToast(
          msg: "name must contain atleast 5 characters");
    } else if (!emailTextEditingController.text.contains("@")) {
      return Fluttertoast.showToast(msg: "Invalid email address");
    } else if (phoneTextEditingController.text.isEmpty) {
      return Fluttertoast.showToast(msg: "Phone Number is required");
    } else if (passwordTextEditingController.text.length < 6) {
      return Fluttertoast.showToast(
          msg: "Password must be atleast 6 characters");
    } else {
      saveTechnicianInfoNow();
    }
  }

  saveTechnicianInfoNow() async {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return MyProgressDialog(message: 'Processing, Please wait');
        });

    final User? firebaseUser = (await firebaseAuth
            .createUserWithEmailAndPassword(
      email: emailTextEditingController.text.trim(),
      password: passwordTextEditingController.text.trim(),
    )
            .catchError((msg) {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Error: $msg');
    }))
        .user;
    if (firebaseUser != null) {
      Map technicianMap = {
        'id': firebaseUser.uid,
        'name': nameTextEditingController.text.trim(),
        'email': emailTextEditingController.text.trim(),
        'phone': phoneTextEditingController.text.trim(),
      };

      DatabaseReference techiniciansRef =
          FirebaseDatabase.instance.ref().child("technicians");
      techiniciansRef.child(firebaseUser.uid).set(technicianMap);

      currentFirebaseUser = firebaseUser;
      Fluttertoast.showToast(msg: 'Account has been created');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (c) => const MyVehicleInfoScreen(),
        ),
      );
    } else {
      Navigator.pop(context);
      Fluttertoast.showToast(msg: 'Account has not been created');
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(50),
                    child: Image.asset('assets/images/technician.png'),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Register as Technician',
                    style: TextStyle(
                      fontSize: 28,
                      color: Color.fromARGB(255, 72, 147, 137),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: TextField(
                      controller: nameTextEditingController,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 51, 44, 44),
                      ),
                      decoration: const InputDecoration(
                        labelText: 'Name',
                        hintText: 'Name',
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
                  TextField(
                    controller: phoneTextEditingController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 51, 44, 44),
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Phone Number',
                      hintText: 'Phone Number',
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
                        borderSide: BorderSide(
                            color: Color.fromARGB(136, 158, 158, 158)),
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
                      // Navigator.push(
                      //   context,
                      //   // MaterialPageRoute(
                      //   //   builder: (c) => const MyVehicleInfoScreen(),
                      //   // ),
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 72, 147, 137),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  TextButton(
                    child: const Text(
                      "Already have an Account? Login Here",
                      style: TextStyle(color: Colors.grey),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (c) => const MyLoginScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            )));
  }
}
