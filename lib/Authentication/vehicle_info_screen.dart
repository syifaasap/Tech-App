import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:tech_app/Global/global.dart';
import 'package:tech_app/splash_screen.dart';

class MyVehicleInfoScreen extends StatefulWidget {
  const MyVehicleInfoScreen({super.key});

  @override
  State<MyVehicleInfoScreen> createState() {
    return _MyVehicleInfoScreenState();
  }
}

class _MyVehicleInfoScreenState extends State<MyVehicleInfoScreen> {
  TextEditingController vehicleModelTextEditingController =
      TextEditingController();
  TextEditingController vehicleNumberTextEditingController =
      TextEditingController();
  TextEditingController vehicleColorTextEditingController =
      TextEditingController();

  List<String> vehicleTypeList = ['car', 'motorcycle', 'van'];
  String? selectedVehicleType;

  saveVehicleInfo() {
    Map technicianVehicleInfoMap = {
      'vehicle_color': vehicleColorTextEditingController.text.trim(),
      'vehicle_number': vehicleNumberTextEditingController.text.trim(),
      'vehicle_model': vehicleModelTextEditingController.text.trim(),
      'type': selectedVehicleType,
    };

    DatabaseReference techiniciansRef =
        FirebaseDatabase.instance.ref().child("technicians");
    techiniciansRef
        .child(currentFirebaseUser!.uid)
        .child('vehicle_details')
        .set(technicianVehicleInfoMap);

    Fluttertoast.showToast(
        msg: 'Congratulations!, Vehicle Details has been saved');

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => const MySplashScreen(),
      ),
    );
  }

  @override
  Widget build(context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(30),
                child: Image.asset('assets/images/vehicle.png'),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Vehicle Details',
                style: TextStyle(
                  fontSize: 28,
                  color: Color.fromARGB(255, 72, 147, 137),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  top: 30,
                ),
                child: TextField(
                  controller: vehicleModelTextEditingController,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 51, 44, 44),
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Vehicle Model',
                    hintText: 'Vehicle Model',
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(136, 158, 158, 158),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(136, 158, 158, 158),
                      ),
                    ),
                    hintStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                    labelStyle: TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              TextField(
                controller: vehicleNumberTextEditingController,
                style: const TextStyle(
                  color: Color.fromARGB(255, 51, 44, 44),
                ),
                decoration: const InputDecoration(
                  labelText: 'Vehicle Number',
                  hintText: 'Vehicle Number',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(136, 158, 158, 158),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide:
                        BorderSide(color: Color.fromARGB(136, 158, 158, 158)),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              TextField(
                controller: vehicleColorTextEditingController,
                style: const TextStyle(
                  color: Color.fromARGB(255, 51, 44, 44),
                ),
                decoration: const InputDecoration(
                  labelText: 'Vehicle Color',
                  hintText: 'Vehicle Color',
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(136, 158, 158, 158),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(136, 158, 158, 158),
                    ),
                  ),
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                  labelStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ),
              DropdownButton(
                dropdownColor: const Color.fromARGB(255, 49, 63, 70),
                icon: const Icon(Icons.arrow_drop_down_rounded),
                iconSize: 30,
                hint: const Text(
                  'Choose your Vehicle',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                value: selectedVehicleType,
                onChanged: (newValue) {
                  setState(() {
                    selectedVehicleType = newValue.toString();
                  });
                },
                items: vehicleTypeList.map((vehicle) {
                  return DropdownMenuItem(
                    value: vehicle,
                    child: Text(
                      vehicle,
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (vehicleColorTextEditingController.text.isNotEmpty &&
                      vehicleNumberTextEditingController.text.isNotEmpty &&
                      vehicleModelTextEditingController.text.isNotEmpty &&
                      selectedVehicleType != null) {
                    saveVehicleInfo();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 72, 147, 137),
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
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
