import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserServiceRequestInfo {
  LatLng? originLatLng;
  LatLng? destinationLatLng;
  String? originAddress;
  String? destinationAddress;
  String? serviceRequestId;
  String? userName;
  String? userPhone;

  UserServiceRequestInfo({
    this.originLatLng,
    this.destinationLatLng,
    this.originAddress,
    this.destinationAddress,
    this.serviceRequestId,
    this.userName,
    this.userPhone,
  });
}
