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
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 40, left: 40, right: 40),
                    child: Image.asset("assets/images/dispatch.png"),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Text(
                          'Create your Account',
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
                      controller: nameTextEditingController,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 51, 44, 44),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Name',
                        hintText: 'Name',
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
                            fontFamily: "PTSans"),
                        labelStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                            fontFamily: "PTSans"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
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
                            fontFamily: "PTSans"),
                        labelStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                            fontFamily: "PTSans"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 51, 44, 44),
                      ),
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        hintText: 'Phone Number',
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
                            fontFamily: "PTSans"),
                        labelStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                            fontFamily: "PTSans"),
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
                            fontFamily: "PTSans"),
                        labelStyle: TextStyle(
                            color: Colors.grey[500],
                            fontSize: 14,
                            fontFamily: "PTSans"),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                    child: ElevatedButton(
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
                        backgroundColor:
                            const Color.fromARGB(255, 56, 120, 240),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      child: const Center(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text(
                            'Create Account',
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
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            "Already have an Account? Login Here",
                            style: TextStyle(color: Colors.grey),
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
