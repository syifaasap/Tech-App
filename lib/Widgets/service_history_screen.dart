import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tech_app/InfoHandler/info_handler_app.dart';
import 'package:tech_app/Widgets/history_design_ui.dart';

class ServiceHistoryScreen extends StatefulWidget {
  const ServiceHistoryScreen({super.key});

  @override
  State<ServiceHistoryScreen> createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 35, 53, 88),
        title: const Text(
          "Service History",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, fontFamily: "PTSans"),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          color: Colors.grey[100],
          onPressed: () {
            SystemNavigator.pop();
          },
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, i) => const Divider(
          color: Colors.white,
          thickness: 0,
          height: 0,
        ),
        itemBuilder: (context, i) {
          return Card(
            color: Colors.white,
            shadowColor: Colors.grey[700],
            child: HistoryDesignUIWidget(
              serviceHistoryModel: Provider.of<InfoApp>(context, listen: false)
                  .allServiceHistoryInformationList[i],
            ),
          );
        },
        itemCount: Provider.of<InfoApp>(context, listen: false)
            .allServiceHistoryInformationList
            .length,
        physics: const ClampingScrollPhysics(),
        shrinkWrap: true,
      ),
    );
  }
}
