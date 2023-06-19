import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tech_app/Global/global.dart';
import 'package:tech_app/Widgets/info_design.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  State<ProfileTabPage> createState() {
    return _ProfileTabPageState();
  }
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                width: 120,
                height: 120,
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              //name
              Text(
                onlineTechnicianData!.name!,
                style: const TextStyle(
                  fontSize: 30.0,
                  color: Color.fromARGB(255, 35, 53, 88),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Text(
                "${titleStarsRating!} technician",
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey[500],
                ),
              ),
              const SizedBox(
                height: 10,
                width: 200,
              ),

              const SizedBox(
                height: 15.0,
              ),

              //phone
              InfoDesignUI(
                textInfo: onlineTechnicianData!.phone!,
                iconData: Icons.phone_iphone_rounded,
              ),

              //email
              InfoDesignUI(
                textInfo: onlineTechnicianData!.email!,
                iconData: Icons.email_rounded,
              ),

              //email
              InfoDesignUI(
                  textInfo: "${onlineTechnicianData!.vehicle_color!},  ${onlineTechnicianData!.vehicle_model!},  ${onlineTechnicianData!.vehicle_number!}",
                  iconData: Icons.car_repair_rounded),

              const SizedBox(
                height: 20,
              ),

              ElevatedButton(
                onPressed: () {
                  firebaseAuth.signOut();
                  SystemNavigator.pop();
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 56, 120, 240),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    )),
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                  child: Text(
                    "Log Out",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontFamily: "PTSans",
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
