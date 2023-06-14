import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:tech_app/Global/global.dart';
import 'package:tech_app/Widgets/fare_amount_collection.dart';
import 'Assists/assists_method.dart';
import 'Models/user_service_request_info.dart';
import 'Widgets/progress_dialog.dart';

class NewServiceSreen extends StatefulWidget {
  UserServiceRequestInfo? userServiceRequestInfoDetails;
  NewServiceSreen({
    super.key,
    this.userServiceRequestInfoDetails,
  });

  @override
  State<NewServiceSreen> createState() {
    return _NewServiceSreenState();
  }
}

class _NewServiceSreenState extends State<NewServiceSreen> {
  GoogleMapController? newServiceGoogleMapController;
  final Completer<GoogleMapController> _controllerMap =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  String buttonTitle = "Arrived";
  Color? buttonColors = const Color.fromARGB(255, 72, 147, 137);
  String statusButton = "accepted";

  Set<Marker> setOfMarkers = <Marker>{};
  Set<Circle> setOfCircle = <Circle>{};
  Set<Polyline> setOfPolyline = <Polyline>{};
  List<LatLng> polyLinePositionCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  double mapPadding = 0;
  BitmapDescriptor? iconAnimatedMarker;

  var geoLocator = Geolocator();
  Position? onlineTechnicianCurrentPosition;

  String? serviceRequestStatus = "accepted";
  String? durationFromOriginToDestination = "";

  bool isRequestDirectionDetail = false;

  //1. When technician accept user service request
  //Origin LatLng -> technician current position
  //Destination LatLng -> user PickUp location

  //2. When technician picked up the user
  //Origin LatLng -> user PickUp location = technician current location
  //Destination LatLng -> user DropOff location

  Future<void> drawPolyLineFromOriginToDestination(
      LatLng originLatLng, LatLng destinationLatLng) async {
    showDialog(
      context: context,
      builder: (BuildContext context) => MyProgressDialog(
        message: "Please wait...",
      ),
    );

    var directionDetailsInfo =
        await AssistsMethods.obtainOriginToDestinationDirectionDetails(
            originLatLng, destinationLatLng);

    Navigator.pop(context);

    print("These are points = ");
    print(directionDetailsInfo!.e_point);

    PolylinePoints pPoints = PolylinePoints();
    List<PointLatLng> decodedPolyLinePointsResultList =
        pPoints.decodePolyline(directionDetailsInfo.e_point!);

    polyLinePositionCoordinates.clear();

    if (decodedPolyLinePointsResultList.isNotEmpty) {
      for (var pointLatLng in decodedPolyLinePointsResultList) {
        polyLinePositionCoordinates
            .add(LatLng(pointLatLng.latitude, pointLatLng.longitude));
      }
    }

    setOfPolyline.clear();

    setState(() {
      Polyline polyline = Polyline(
        color: const Color.fromARGB(255, 72, 147, 137),
        polylineId: const PolylineId("PolylineID"),
        jointType: JointType.round,
        points: polyLinePositionCoordinates,
        startCap: Cap.roundCap,
        endCap: Cap.roundCap,
        geodesic: true,
      );

      setOfPolyline.add(polyline);
    });

    LatLngBounds boundsLatLng;
    if (originLatLng.latitude > destinationLatLng.latitude &&
        originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng =
          LatLngBounds(southwest: destinationLatLng, northeast: originLatLng);
    } else if (originLatLng.longitude > destinationLatLng.longitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(originLatLng.latitude, destinationLatLng.longitude),
        northeast: LatLng(destinationLatLng.latitude, originLatLng.longitude),
      );
    } else if (originLatLng.latitude > destinationLatLng.latitude) {
      boundsLatLng = LatLngBounds(
        southwest: LatLng(destinationLatLng.latitude, originLatLng.longitude),
        northeast: LatLng(originLatLng.latitude, destinationLatLng.longitude),
      );
    } else {
      boundsLatLng =
          LatLngBounds(southwest: originLatLng, northeast: destinationLatLng);
    }

    newServiceGoogleMapController!
        .animateCamera(CameraUpdate.newLatLngBounds(boundsLatLng, 65));

    Marker originMarker = Marker(
      markerId: const MarkerId('originID'),
      position: originLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
    );

    Marker destinationMarker = Marker(
      markerId: const MarkerId('destinationID'),
      position: destinationLatLng,
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
    );

    setState(() {
      setOfMarkers.add(originMarker);
      setOfMarkers.add(destinationMarker);
    });

    // Mengatur Circle
    Circle originCircle = Circle(
      circleId: const CircleId('originID'),
      fillColor: const Color.fromARGB(255, 224, 145, 60),
      radius: 12,
      strokeWidth: 5,
      strokeColor: Colors.white38,
      center: originLatLng,
    );

    Circle destinationCircle = Circle(
      circleId: const CircleId('destinationID'),
      fillColor: const Color.fromARGB(255, 219, 69, 69),
      radius: 12,
      strokeWidth: 5,
      strokeColor: Colors.white38,
      center: destinationLatLng,
    );
    setState(() {
      setOfCircle.add(originCircle);
      setOfCircle.add(destinationCircle);
    });
  }

  @override
  void initState() {
    super.initState();
    saveAssignTechnicianDetailsToUserServiceRequest();
  }

  createTechnicianIconMarker() {
    if (iconAnimatedMarker == null) {
      ImageConfiguration imageConfiguration =
          createLocalImageConfiguration(context, size: const Size(2, 2));
      BitmapDescriptor.fromAssetImage(
              imageConfiguration, "assets/images/map_point.png")
          .then((value) {
        iconAnimatedMarker = value;
      });
    }
  }

  getTechnicianLocationUpdateRealTime() {
    LatLng oldLatLng = const LatLng(0, 0);

    //Mendapatkan atau update lokasi dari technician yang online
    streamSubscriptionLivePosition =
        Geolocator.getPositionStream().listen((Position position) {
      technicianCurrentPosition = position;
      onlineTechnicianCurrentPosition = position;

      LatLng latLngLiveTechnicianPosition = LatLng(
          onlineTechnicianCurrentPosition!.latitude,
          onlineTechnicianCurrentPosition!.longitude);

      Marker animatingMarker = Marker(
          markerId: const MarkerId("AnimatedMarker"),
          position: latLngLiveTechnicianPosition,
          icon: iconAnimatedMarker!,
          infoWindow: const InfoWindow(title: "This is your position"));

      setState(() {
        CameraPosition cameraPosition =
            CameraPosition(target: latLngLiveTechnicianPosition, zoom: 16);
        newServiceGoogleMapController!
            .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
        setOfMarkers.removeWhere(
            (element) => element.markerId.value == "AnimatedMarker");
        setOfMarkers.add(animatingMarker);
      });

      oldLatLng = latLngLiveTechnicianPosition;
      updateDurationTimeAtRealTime();

      // Update lokasi technician real time di database
      Map techicianLatLngDataMap = {
        "latitude": onlineTechnicianCurrentPosition!.latitude.toString(),
        "longitude": onlineTechnicianCurrentPosition!.longitude.toString(),
      };

      FirebaseDatabase.instance
          .ref()
          .child("All Service Request")
          .child(widget.userServiceRequestInfoDetails!.serviceRequestId!)
          .child("technicianLocation")
          .set(techicianLatLngDataMap);
    });
  }

  updateDurationTimeAtRealTime() async {
    if (isRequestDirectionDetail == false) {
      isRequestDirectionDetail = true;

      if (onlineTechnicianCurrentPosition == null) {
        return;
      }

      var originLatLng = LatLng(onlineTechnicianCurrentPosition!.latitude,
          onlineTechnicianCurrentPosition!.longitude); //Driver current location

      LatLng? destinationLatLng;

      if (serviceRequestStatus == "accepted") {
        destinationLatLng = widget
            .userServiceRequestInfoDetails!.originLatLng; //User PickUp location
      } else //Technician Arrived
      {
        destinationLatLng = widget.userServiceRequestInfoDetails!
            .destinationLatLng; //User DropOff location
      }

      var directionInfo =
          await AssistsMethods.obtainOriginToDestinationDirectionDetails(
              originLatLng, destinationLatLng!);

      if (directionInfo != null) {
        setState(() {
          durationFromOriginToDestination = directionInfo.duration_text!;
        });
      }
      isRequestDirectionDetail = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    createTechnicianIconMarker();

    return Scaffold(
      body: Stack(
        children: [
          //Google Map
          GoogleMap(
            padding: EdgeInsets.only(bottom: mapPadding),
            mapType: MapType.normal,
            myLocationEnabled: true,
            initialCameraPosition: _kGooglePlex,
            markers: setOfMarkers,
            circles: setOfCircle,
            polylines: setOfPolyline,
            onMapCreated: (GoogleMapController controller) {
              _controllerMap.complete(controller);
              newServiceGoogleMapController = controller;

              setState(() {
                mapPadding = 350;
              });

              var technicianCurrentLatLng = LatLng(
                  technicianCurrentPosition!.latitude,
                  technicianCurrentPosition!.longitude);

              var userPickUpLatLng =
                  widget.userServiceRequestInfoDetails!.originLatLng;

              drawPolyLineFromOriginToDestination(
                  technicianCurrentLatLng, userPickUpLatLng!);

              getTechnicianLocationUpdateRealTime();
            },
          ),

          //UI
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.transparent,
                    blurRadius: 18,
                    spreadRadius: 18,
                    offset: Offset(0.6, 0.6),
                  ),
                ],
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                child: Column(
                  children: [
                    // Duration
                    Text(
                      durationFromOriginToDestination!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 72, 147, 137),
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    // Username - Icon
                    Row(
                      children: [
                        Text(
                          widget.userServiceRequestInfoDetails!.userName!,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 72, 147, 137),
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.phone_android_rounded,
                            color: Colors.grey,
                          ),
                        )
                      ],
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    //User PickUp Location - Icon
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
                              widget.userServiceRequestInfoDetails!
                                  .originAddress!,
                              style: const TextStyle(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(
                      height: 20,
                    ),

                    // User DropOff Location - Icon
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
                    const SizedBox(
                      height: 18,
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Colors.grey,
                    ),

                    const SizedBox(
                      height: 25,
                    ),

                    ElevatedButton.icon(
                      onPressed: () async {
                        //technican arrived in user PickUp location
                        if (serviceRequestStatus ==
                            "accepted") //technician arrived at user pickup location
                        {
                          serviceRequestStatus = "arrived";

                          FirebaseDatabase.instance
                              .ref()
                              .child("All Service Request")
                              .child(widget.userServiceRequestInfoDetails!
                                  .serviceRequestId!)
                              .child("status")
                              .set(serviceRequestStatus);

                          setState(() {
                            buttonTitle = "Let's Start"; // Start Service
                            buttonColors = Colors.blueGrey;
                          });

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) => MyProgressDialog(
                              message: "Loading...",
                            ),
                          );
                          await drawPolyLineFromOriginToDestination(
                              widget
                                  .userServiceRequestInfoDetails!.originLatLng!,
                              widget.userServiceRequestInfoDetails!
                                  .destinationLatLng!);

                          Navigator.pop(context);
                        }
                        //user ready - start service - Let's start
                        else if (serviceRequestStatus == "arrived") {
                          serviceRequestStatus = "onservice";

                          FirebaseDatabase.instance
                              .ref()
                              .child("All Service Request")
                              .child(widget.userServiceRequestInfoDetails!
                                  .serviceRequestId!)
                              .child("status")
                              .set(serviceRequestStatus);

                          setState(() {
                            buttonTitle = "End Trip"; //end the trip
                            buttonColors = Colors.redAccent;
                          });
                        }
                        //[user/technician reached to the dropOff Destination Location] - End Trip Button
                        else if (serviceRequestStatus == "onservice") {
                          endServiceNow();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColors,
                      ),
                      icon: const Icon(
                        Icons.directions_car_rounded,
                        color: Colors.white,
                        size: 25,
                      ),
                      label: Text(
                        buttonTitle,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  endServiceNow() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => MyProgressDialog(
        message: "Please wait...",
      ),
    );

    //get the tripDirectionDetails = distance travelled
    var currentTechnicianPositionLatLng = LatLng(
      onlineTechnicianCurrentPosition!.latitude,
      onlineTechnicianCurrentPosition!.longitude,
    );

    var serviceDirectionDetails =
        await AssistsMethods.obtainOriginToDestinationDirectionDetails(
            currentTechnicianPositionLatLng,
            widget.userServiceRequestInfoDetails!.originLatLng!);

    //fare amount
    double totalFareAmount =
        AssistsMethods.calculateFareAmountFromOrigintoDestination(
            serviceDirectionDetails!);

    FirebaseDatabase.instance
        .ref()
        .child("All Service Request")
        .child(widget.userServiceRequestInfoDetails!.serviceRequestId!)
        .child("fareAmount")
        .set(totalFareAmount.toString());

    FirebaseDatabase.instance
        .ref()
        .child("All Service Request")
        .child(widget.userServiceRequestInfoDetails!.serviceRequestId!)
        .child("status")
        .set("ended");

    streamSubscriptionLivePosition!.cancel();

    Navigator.pop(context);

    //Display fare amount
    showDialog(
      context: context,
      builder: (BuildContext context) =>
          FareAmountCollection(totalFareAmount: totalFareAmount),
    );
    //save fare amount to technician total earnings
    saveFareAmountTechnicianEarnings(totalFareAmount);
  }

  saveFareAmountTechnicianEarnings(double totalFareAmount) {
    FirebaseDatabase.instance
        .ref()
        .child("technicians")
        .child(currentFirebaseUser!.uid)
        .child("earnings")
        .once()
        .then((snap) {
      if (snap.snapshot.value != null) //earnings sub Child exists
      {
        //12
        double oldEarnings = double.parse(snap.snapshot.value.toString());
        double technicianTotalEarnings = totalFareAmount + oldEarnings;

        FirebaseDatabase.instance
            .ref()
            .child("technicians")
            .child(currentFirebaseUser!.uid)
            .child("earnings")
            .set(technicianTotalEarnings.toString());
      } else //earnings sub Child do not exists
      {
        FirebaseDatabase.instance
            .ref()
            .child("technicians")
            .child(currentFirebaseUser!.uid)
            .child("earnings")
            .set(totalFareAmount.toString());
      }
    });
  }

  saveAssignTechnicianDetailsToUserServiceRequest() {
    DatabaseReference databaseReference = FirebaseDatabase.instance
        .ref()
        .child("All Service Request")
        .child(widget.userServiceRequestInfoDetails!.serviceRequestId!);

    Map technicianLocationDataMap = {
      "latitude": technicianCurrentPosition!.latitude.toString(),
      "longitude": technicianCurrentPosition!.longitude.toString(),
    };
    databaseReference
        .child("technicianLocation")
        .set(technicianLocationDataMap);

    databaseReference.child("status").set("accepted");
    databaseReference.child("technicianId").set(onlineTechnicianData!.id);
    databaseReference.child("technicianName").set(onlineTechnicianData!.name);
    databaseReference.child("technicianPhone").set(onlineTechnicianData!.phone);
    databaseReference.child("vehicle_details").set(
        onlineTechnicianData!.vehicle_color.toString() +
            " " +
            onlineTechnicianData!.vehicle_model.toString() +
            "" +
            onlineTechnicianData!.vehicle_number.toString());
  }

  // saveServiceRequestIdToTechnicianHistory() {
  //   DatabaseReference serviceHistoryreference = FirebaseDatabase.instance
  //       .ref()
  //       .child("technicians")
  //       .child(currentFirebaseUser!.uid)
  //       .child("serviceHistory");

  //   serviceHistoryreference
  //       .child(widget.userServiceRequestInfoDetails!.serviceRequestId!)
  //       .set(true);
  // }
}
