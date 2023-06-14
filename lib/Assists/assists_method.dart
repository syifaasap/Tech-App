import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tech_app/Assists/request_assists.dart';
import 'package:tech_app/Models/service_history_model.dart';
import '../Global/global.dart';
import '../Global/google_maps_key.dart';
import '../InfoHandler/direction_handler.dart';
import '../InfoHandler/info_handler_app.dart';
import '../Models/directions_details.dart';

class AssistsMethods {
  static Future<String> searchAddressForGeoCoordinates(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "Error Occurred, Failed. No Response.") {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<InfoApp>(context, listen: false)
          .updatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }

  // static void readCurrentOnlineUserInfo() async {
  //   currentFirebaseUser = firebaseAuth.currentUser;

  //   DatabaseReference userRef = FirebaseDatabase.instance
  //       .ref()
  //       .child("users")
  //       .child(currentFirebaseUser!.uid);

  //   userRef.once().then((snap) {
  //     if (snap.snapshot.value != null) {
  //       userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
  //     }
  //   });
  // }

  static Future<DirectionDetailInfo?> obtainOriginToDestinationDirectionDetails(
      LatLng originPosition, LatLng destinationPosition) async {
    String urlOriginToDestinationDirectionDetails =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${originPosition.latitude},${originPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionAPI = await RequestAssistant.receiveRequest(
        urlOriginToDestinationDirectionDetails);

    if (responseDirectionAPI == "Error Occurred, Failed. No Response.") {
      return null;
    }

    DirectionDetailInfo directionDetailsInfo = DirectionDetailInfo();
    directionDetailsInfo.e_point =
        responseDirectionAPI["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text =
        responseDirectionAPI["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value =
        responseDirectionAPI["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text =
        responseDirectionAPI["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value =
        responseDirectionAPI["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }

  static pauseLiveLocationUpdates() {
    streamSubscriptionPosition!.pause();
    Geofire.removeLocation(currentFirebaseUser!.uid);
  }

  static resumeLiveLocationUpdates() {
    streamSubscriptionPosition!.resume();
    Geofire.setLocation(
        currentFirebaseUser!.uid,
        technicianCurrentPosition!.latitude,
        technicianCurrentPosition!.longitude);
  }

  static double calculateFareAmountFromOrigintoDestination(
      DirectionDetailInfo directionDetailsInfo) {
    double timeTraveledFareAmountPerMinute =
        (directionDetailsInfo.duration_value! / 60) * 0.1;
    double distanceTraveledFareAmountPerKilometer =
        (directionDetailsInfo.duration_value! / 1000) * 0.1;

    double totalFareAmount = timeTraveledFareAmountPerMinute +
        distanceTraveledFareAmountPerKilometer * 15000;

    if (technicianVehicleType == "motorcycle") {
      double resultFareAmount = (totalFareAmount.truncate()) / 2.0;
      return resultFareAmount;
    } else if (technicianVehicleType == "car") {
      return totalFareAmount.truncate().toDouble();
    } else if (technicianVehicleType == "van") {
      double resultFareAmount = (totalFareAmount.truncate()) * 2.0;
      return resultFareAmount;
    } else {
      return totalFareAmount.truncate().toDouble();
    }
  }

  //retrieve the service KEYS for online user
  //service key = service request key
  static void readServiceKeysForOnlineTechnician(context) {
    FirebaseDatabase.instance
        .ref()
        .child("All Service Request")
        .orderByChild("technicianId")
        .equalTo(firebaseAuth.currentUser!.uid)
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        Map keysServiceId = snap.snapshot.value as Map;

        //count total number services and share it with Provider
        int overAllServiceCounter = keysServiceId.length;
        Provider.of<InfoApp>(context, listen: false)
            .updateOverAllServiceCounter(overAllServiceCounter);

        //share services keys with Provider
        List<String> serviceKeysList = [];
        keysServiceId.forEach((key, value) {
          serviceKeysList.add(key);
        });
        Provider.of<InfoApp>(context, listen: false)
            .updateOverAllServiceKeys(serviceKeysList);

        //get services keys data - read services complete information
        readServiceHistoryInformation(context);
      }
    });
  }

  static void readServiceHistoryInformation(context) {
    var servicesAllKeys =
        Provider.of<InfoApp>(context, listen: false).historyServiceKeysList;

    for (String eachKey in servicesAllKeys) {
      FirebaseDatabase.instance
          .ref()
          .child("All Service Request")
          .child(eachKey)
          .once()
          .then((snap) {
        var eachServiceHistory =
            ServiceHistoryModel.fromSnapshot(snap.snapshot);

        if ((snap.snapshot.value as Map)["status"] == "ended") {
          //update-add each history to OverAllService History Data List
          Provider.of<InfoApp>(context, listen: false)
              .updateOverAllServiceHistoryInformation(eachServiceHistory);
        }
      });
    }
  }

  //readTechnicianEarnings
  static void readTechnicianEarnings(context) {
    FirebaseDatabase.instance
        .ref()
        .child("technicians")
        .child(firebaseAuth.currentUser!.uid)
        .child("earnings")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String technicianEarnings = snap.snapshot.value.toString();
        Provider.of<InfoApp>(context, listen: false)
            .updateTechnicianTotalEarnings(technicianEarnings);
      }
    });

    readServiceKeysForOnlineTechnician(context);
  }

  static void readTechnicianRatings(context) {
    FirebaseDatabase.instance
        .ref()
        .child("technicians")
        .child(firebaseAuth.currentUser!.uid)
        .child("ratings")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) {
        String technicianRatings = snap.snapshot.value.toString();
        Provider.of<InfoApp>(context, listen: false)
            .updateTechnicianAverageRatings(technicianRatings);
      }
    });
  }
}
