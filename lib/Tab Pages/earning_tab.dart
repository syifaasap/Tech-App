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
            color: Color.fromARGB(255, 72, 147, 137),
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 80),
              child: Column(
                children: [
                  const Text(
                    "Your Earnings:",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Rp " +
                        Provider.of<InfoApp>(context, listen: false)
                            .technicianTotalEarnings,
                    style: const TextStyle(
                      color: Colors.orange,
                      fontSize: 60,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          //total number of trips
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (c) => ServiceHistoryScreen()));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Image.asset(
                    "assets/images/car.png",
                    width: 60,
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  const Text(
                    "Services Completed",
                    style: TextStyle(
                      color: Colors.black54,
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
                          color: Colors.orange,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
