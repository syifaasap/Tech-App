//import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tech_app/Assists/assists_method.dart';
import 'package:tech_app/Global/global.dart';
import 'package:tech_app/service_screen.dart';
import '../Models/user_service_request_info.dart';

class DialogBoxNotification extends StatefulWidget {
  UserServiceRequestInfo? userServiceRequestInfoDetails;
  DialogBoxNotification({super.key, this.userServiceRequestInfoDetails});

  @override
  State<DialogBoxNotification> createState() {
    return _DialogBoxNotificationState();
  }
}

class _DialogBoxNotificationState extends State<DialogBoxNotification> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Colors.transparent,
      elevation: 5,
      child: Container(
        margin: const EdgeInsets.all(8),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 25,
            ),
            Image.asset(
              "assets/images/mechanic.png",
              width: 100,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "New Service Request",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            const SizedBox(
              height: 12,
            ),

            //Address -> Origin Destination
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  // Origin Location Icon
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/origin.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget
                                .userServiceRequestInfoDetails!.originAddress!,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  // Destination Location Icon
                  Row(
                    children: [
                      Image.asset(
                        "assets/images/destination.png",
                        width: 30,
                        height: 30,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      Expanded(
                        child: Container(
                          child: Text(
                            widget.userServiceRequestInfoDetails!
                                .destinationAddress!,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(
              height: 1,
              thickness: 1,
              color: Colors.grey,
            ),

            //Buttons -> Cancel Accept
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    onPressed: () {
                      assetsAudioPlayer.stop();
                      assetsAudioPlayer.pause();
                      assetsAudioPlayer = AssetsAudioPlayer();

                      //Cancel service request
                      FirebaseDatabase.instance
                          .ref()
                          .child("All Service Request")
                          .child(widget
                              .userServiceRequestInfoDetails!.serviceRequestId!)
                          .remove()
                          .then((value) {
                        FirebaseDatabase.instance
                            .ref()
                            .child("technicians")
                            .child(currentFirebaseUser!.uid)
                            .child("newServiceStatus")
                            .set("idle");
                      }).then((value) {
                        FirebaseDatabase.instance
                            .ref()
                            .child("technicians")
                            .child(currentFirebaseUser!.uid)
                            .child("serviceHistory")
                            .child(widget.userServiceRequestInfoDetails!
                                .serviceRequestId!)
                            .remove();
                      }).then((value) {
                        Fluttertoast.showToast(
                            msg:
                                "Service Request has been Cancelled, Successfully. Restart App Now.");
                      });
                      Future.delayed(const Duration(milliseconds: 3000), () {
                        SystemNavigator.pop();
                      });
                    },
                    child: Text(
                      "Cancel".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 72, 147, 137),
                    ),
                    onPressed: () {
                      assetsAudioPlayer.stop();
                      assetsAudioPlayer.pause();
                      assetsAudioPlayer = AssetsAudioPlayer();
                      //Accept service request
                      acceptServiceRequest(context);
                    },
                    child: Text(
                      "Accept".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  acceptServiceRequest(BuildContext context) {
    String getServiceRequestId = "";
    FirebaseDatabase.instance
        .ref()
        .child("technicians")
        .child(currentFirebaseUser!.uid)
        .child("newServiceStatus")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        getServiceRequestId = snap.snapshot.value.toString();
      } else {
        Fluttertoast.showToast(msg: "This service request do not exist.");
      }

      if (getServiceRequestId ==
          widget.userServiceRequestInfoDetails!.serviceRequestId) {
        FirebaseDatabase.instance
            .ref()
            .child("technicians")
            .child(currentFirebaseUser!.uid)
            .child("newServiceStatus")
            .set("accepted");

        AssistsMethods.pauseLiveLocationUpdates();
        // Service started = Send Technician to newServiceScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewServiceSreen(
                userServiceRequestInfoDetails:
                    widget.userServiceRequestInfoDetails),
          ),
        );
      } else {
        Fluttertoast.showToast(msg: "This service request do not exist");
      }
    });
  }
}
