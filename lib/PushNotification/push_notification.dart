import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tech_app/Global/global.dart';
import 'package:tech_app/Models/user_service_request_info.dart';
import 'package:tech_app/PushNotification/dialog_box_notification.dart';

class PushNotification {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  Future initializeCloudMessaging(BuildContext context) async {
    // Terminated State Messages = Aplikasi dalam keadaan off, dan dibuka langsung dari push notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? remoteMessage) {
      if (remoteMessage != null) {
        print("This is Service Request Id :");
        print(remoteMessage.data["serviceRequestId"]);
        // Display Service Request Information - user information who request a service
        readUserServiceRequestInfo(
            remoteMessage.data["serviceRequestId"], context);
      }
    });

    // Foreground State Messages = Aplikasi dalam keadaan on, dan menerima push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? remoteMessage) {
      // Display Service Request Information - user information who request a service
      readUserServiceRequestInfo(
          remoteMessage!.data["serviceRequestId"], context);
    });

    // Background State Messages = Aplikasi dalam background, dan dibuka langsung dari push notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? remoteMessage) {
      // Display Service Request Information - user information who request a service
      readUserServiceRequestInfo(
          remoteMessage!.data["serviceRequestId"], context);
    });
  }

  readUserServiceRequestInfo(
      String userServiceRequestId, BuildContext context) {
    FirebaseDatabase.instance
        .ref()
        .child("All Service Request")
        .child(userServiceRequestId)
        .once()
        .then((snapData) {
      if (snapData.snapshot.value != null) {
        assetsAudioPlayer.open(Audio("assets/music/music_notification.mp3"));
        assetsAudioPlayer.play();

        double originLat = double.parse(
            (snapData.snapshot.value! as Map)["origin"]["latitude"]);
        double originLng = double.parse(
            (snapData.snapshot.value! as Map)["origin"]["longitude"]);
        String originAddress =
            (snapData.snapshot.value! as Map)["originAddress"];

        double destinationLat = double.parse(
            (snapData.snapshot.value! as Map)["destination"]["latitude"]);
        double destinationLng = double.parse(
            (snapData.snapshot.value! as Map)["destination"]["longitude"]);
        String destinationAddress =
            (snapData.snapshot.value! as Map)["destinationAddress"];

        String userName = (snapData.snapshot.value! as Map)["userName"];
        String userPhone = (snapData.snapshot.value! as Map)["userPhone"];

        String? serviceRequestId = snapData.snapshot.key;

        UserServiceRequestInfo userServiceRequestInfoDetails =
            UserServiceRequestInfo();
        userServiceRequestInfoDetails.originLatLng =
            LatLng(originLat, originLng);
        userServiceRequestInfoDetails.originAddress = originAddress;

        userServiceRequestInfoDetails.destinationLatLng =
            LatLng(destinationLat, destinationLng);
        userServiceRequestInfoDetails.destinationAddress = destinationAddress;

        userServiceRequestInfoDetails.userName = userName;
        userServiceRequestInfoDetails.userPhone = userPhone;

        userServiceRequestInfoDetails.serviceRequestId = serviceRequestId;

        showDialog(
          context: context,
          builder: (BuildContext context) => DialogBoxNotification(
              userServiceRequestInfoDetails: userServiceRequestInfoDetails),
        );
      } else {
        Fluttertoast.showToast(msg: "This Service Request ID doesn't exist.");
      }
    });
  }

  Future generateAndGetToken() async {
    String? registrationToken = await messaging.getToken();
    print("FCM Registration Token = ");
    print(registrationToken);

    FirebaseDatabase.instance
        .ref()
        .child("technicians")
        .child(currentFirebaseUser!.uid)
        .child("token")
        .set(registrationToken);

    messaging.subscribeToTopic("allTechnicians");
    messaging.subscribeToTopic("allUsers");
  }
}
