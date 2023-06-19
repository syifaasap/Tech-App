import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tech_app/InfoHandler/info_handler_app.dart';
import 'package:tech_app/Widgets/service_history_screen.dart';

class MyEarningTab extends StatefulWidget {
  const MyEarningTab({super.key});

  @override
  State<MyEarningTab> createState() {
    return _MyEarningTabState();
  }
}

class _MyEarningTabState extends State<MyEarningTab> {
  @override
  Widget build(context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          //earnings
          Container(
            color: const Color.fromARGB(255, 35, 53, 88),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 30),
              child: Column(
                children: [
                  const Text(
                    "Your Earnings:",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "PTSans"),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Rp ${Provider.of<InfoApp>(context, listen: false)
                            .technicianTotalEarnings}",
                    style: const TextStyle(
                        color: Color.fromARGB(255, 56, 120, 240),
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        fontFamily: "PTSans"),
                  ),
                ],
              ),
            ),
          ),

          //total number of trips

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (c) => const ServiceHistoryScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  shadowColor: Colors.grey[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  )),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  children: [
                    Image.asset(
                      "assets/images/vehicle.png",
                      width: 60,
                    ),
                    const SizedBox(
                      width: 20,
                    ),
                    Text(
                      "Services Completed",
                      style: TextStyle(
                        color: Colors.grey.shade800,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child: Text(
                          Provider.of<InfoApp>(context, listen: false)
                              .allServiceHistoryInformationList
                              .length
                              .toString(),
                          textAlign: TextAlign.end,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "PTSans",
                            color: Color.fromARGB(255, 56, 120, 240),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
