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
                padding: const EdgeInsets.only(
                    top: 40, left: 70, right: 70, bottom: 20),
                child: Image.asset('assets/images/vehicle.png'),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      'Create your Vehicle Details',
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.bold,
                          fontFamily: "PTSans"),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  controller: vehicleModelTextEditingController,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 51, 44, 44),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Vehicle Model',
                    hintText: 'Vehicle Model',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 56, 120, 240),
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        fontFamily: "PTSans"),
                    labelStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                        fontFamily: "PTSans"),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  controller: vehicleNumberTextEditingController,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 51, 44, 44),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Vehicle Number',
                    hintText: 'Vehicle Number',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 56, 120, 240),
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        fontFamily: "PTSans"),
                    labelStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                        fontFamily: "PTSans"),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: TextField(
                  controller: vehicleColorTextEditingController,
                  style: const TextStyle(
                    color: Color.fromARGB(255, 51, 44, 44),
                  ),
                  decoration: InputDecoration(
                    labelText: 'Vehicle Color',
                    hintText: 'Vehicle Color',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey.shade300,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Color.fromARGB(255, 56, 120, 240),
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                    hintStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 12,
                        fontFamily: "PTSans"),
                    labelStyle: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 14,
                        fontFamily: "PTSans"),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DropdownButton(
                    dropdownColor: const Color.fromARGB(255, 35, 53, 88),
                    icon: const Icon(Icons.arrow_drop_down_rounded),
                    iconSize: 30,
                    hint: Text(
                      'Choose your Vehicle',
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "PTSans",
                        color: Colors.grey[300],
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
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                child: ElevatedButton(
                  onPressed: () {
                    if (vehicleColorTextEditingController.text.isNotEmpty &&
                        vehicleNumberTextEditingController.text.isNotEmpty &&
                        vehicleModelTextEditingController.text.isNotEmpty &&
                        selectedVehicleType != null) {
                      saveVehicleInfo();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 56, 120, 240),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      )),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 15),
                      child: Text(
                        'Save Changes',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontFamily: "PTSans",
                            fontWeight: FontWeight.bold),
                      ),
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
