import 'dart:async';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:tech_app/Models/technician_data.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
User? currentFirebaseUser;

StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionLivePosition;
AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();
Position? technicianCurrentPosition;
TechnicianData? onlineTechnicianData = TechnicianData();
String? technicianVehicleType = '';
String? titleStarsRating = "Good";
bool isTechnicianActive = false;
String statusText = 'Currently Offline';
Color buttonColor = Colors.red;
String profileImage = 'assets/images/profile.png';
