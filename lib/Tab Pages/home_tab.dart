import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tech_app/Global/global.dart';
import 'package:tech_app/PushNotification/push_notification.dart';
// import 'package:tech_app/main.dart';
// import 'package:tech_app/main_screen.dart';

import '../Assists/assists_method.dart';
// import '../Global/global.dart';

class MyHomeTab extends StatefulWidget {
  const MyHomeTab({super.key});

  @override
  State<MyHomeTab> createState() {
    return _MyHomeTabState();
  }
}

class _MyHomeTabState extends State<MyHomeTab> {
  GoogleMapController? newGoogleMapController;
  final Completer<GoogleMapController> _controllerMap =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  // Menambahkan Geolocator

  var geoLocator = Geolocator();
  LocationPermission? _locationPermission;

  locationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

// Apabila izin ditolak
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  locateTechnicianPosition() async {
    Position currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    technicianCurrentPosition = currentPosition;

    LatLng latLngPosition = LatLng(technicianCurrentPosition!.latitude,
        technicianCurrentPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 15);
    newGoogleMapController!.animateCamera(
      CameraUpdate.newCameraPosition(cameraPosition),
    );
    // Memberi notifikasi bahwa human readable address berfungsi
    String humanReadableAddress =
        await AssistsMethods.searchAddressForGeoCoordinates(
            technicianCurrentPosition!, context);
    print("this is your address = $humanReadableAddress");

    AssistsMethods.readTechnicianRatings(context);
  }

  readCurrentTechnicianInfo() async {
    currentFirebaseUser = firebaseAuth.currentUser;

    FirebaseDatabase.instance
        .ref()
        .child("technicians")
        .child(currentFirebaseUser!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        onlineTechnicianData!.id = (snap.snapshot.value as Map)["id"];
        onlineTechnicianData!.name = (snap.snapshot.value as Map)["name"];
        onlineTechnicianData!.phone = (snap.snapshot.value as Map)["phone"];
        onlineTechnicianData!.email = (snap.snapshot.value as Map)["email"];

        onlineTechnicianData!.vehicle_color =
            (snap.snapshot.value as Map)["vehicle_details"]["vehicle_color"];
        onlineTechnicianData!.vehicle_model =
            (snap.snapshot.value as Map)["vehicle_details"]["vehicle_model"];
        onlineTechnicianData!.vehicle_number =
            (snap.snapshot.value as Map)["vehicle_details"]["vehicle_number"];

        technicianVehicleType =
            (snap.snapshot.value as Map)["vehicle_details"]["type"];

        print("Vehicle Details :");
        print(onlineTechnicianData!.vehicle_color);
        print(onlineTechnicianData!.vehicle_model);
        print(onlineTechnicianData!.vehicle_number);
      }
    });
    PushNotification pushNotification = PushNotification();
    pushNotification.initializeCloudMessaging(context);
    pushNotification.generateAndGetToken();

    AssistsMethods.readTechnicianEarnings(context);
  }

  @override
  void initState() {
    super.initState();
    locationPermissionAllowed();
    readCurrentTechnicianInfo();
  }

  @override
  Widget build(context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllerMap.complete(controller);
            newGoogleMapController = controller;
            locateTechnicianPosition();
          },
        ),

        // Online Offline Technican UI
        statusText != 'Now Online'
            ? Container(
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                color: Colors.white,
              )
            : Container(),

        // Button for Online Offline Technician
        Positioned(
          top: statusText != 'Now Online'
              ? MediaQuery.of(context).size.height * 0.46
              : 25,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  if (isTechnicianActive != true) // Status Offline
                  {
                    technicianIsOnlineNow();
                    updateTechnicianLocationRealTime();

                    setState(() {
                      statusText = "Now Online";
                      isTechnicianActive = true;
                      buttonColor = Colors.transparent;
                    });
                    //display Toast
                    Fluttertoast.showToast(msg: "You are online now.");
                  } else {
                    technicianIsOfflineNow();
                    setState(() {
                      statusText = "Now Offline";
                      isTechnicianActive = false;
                      buttonColor = Colors.red;
                    });
                    //display Toast
                    Fluttertoast.showToast(msg: "You are offline now.");
                  }
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    )),
                child: statusText != 'Now Online'
                    ? Text(
                        statusText,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(
                        Icons.phonelink_ring_rounded,
                        color: Colors.white,
                        size: 26,
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  technicianIsOnlineNow() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    technicianCurrentPosition = position;

    Geofire.initialize("activeTechnicians");
    Geofire.setLocation(
        currentFirebaseUser!.uid,
        technicianCurrentPosition!.latitude,
        technicianCurrentPosition!.longitude);

    DatabaseReference reference = FirebaseDatabase.instance
        .ref()
        .child("technicians")
        .child(currentFirebaseUser!.uid)
        .child("newServiceStatus");

    reference.set('idle'); //Searching ride request
    reference.onValue.listen((event) {});
  }

  updateTechnicianLocationRealTime() {
    streamSubscriptionPosition =
        Geolocator.getPositionStream().listen((Position position) {
      technicianCurrentPosition = position;
      if (isTechnicianActive == true) {
        Geofire.setLocation(
            currentFirebaseUser!.uid,
            technicianCurrentPosition!.latitude,
            technicianCurrentPosition!.longitude);
      }

      LatLng latLng = LatLng(technicianCurrentPosition!.latitude,
          technicianCurrentPosition!.longitude);

      newGoogleMapController!.animateCamera(CameraUpdate.newLatLng(latLng));
    });
  }

  technicianIsOfflineNow() {
    Geofire.removeLocation(currentFirebaseUser!.uid);
    DatabaseReference? reference = FirebaseDatabase.instance
        .ref()
        .child('technicians')
        .child('currentFirebaseUser!.uid')
        .child('newServiceStatus');

    reference.onDisconnect();
    reference.remove();
    reference = null;

    Future.delayed(const Duration(milliseconds: 2000), () {
      // SystemChannels.platform.invokeMethod('SystemNavigator.pop();');
      SystemNavigator.pop();

      // //MyApp.restartApp(context);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(
      //     builder: (c) => const MyMainScreen(),
      //   ),
      // );
    });
  }
}
