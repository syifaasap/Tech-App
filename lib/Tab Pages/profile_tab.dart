import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
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
      backgroundColor: Color.fromARGB(255, 72, 147, 137),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //name
            Text(
              onlineTechnicianData!.name!,
              style: const TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            Text(
              titleStarsRating! + " " + "technician",
              style: const TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
            ),
            const SizedBox(
              height: 10,
              width: 200,
            ),

            const SizedBox(
              height: 25.0,
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
                textInfo: onlineTechnicianData!.vehicle_color! +
                    "" +
                    onlineTechnicianData!.vehicle_model! +
                    "" +
                    onlineTechnicianData!.vehicle_number!,
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
                backgroundColor: Colors.red,
              ),
              child: const Text(
                "Log Out",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
