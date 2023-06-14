import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tech_app/InfoHandler/info_handler_app.dart';
import 'package:tech_app/Widgets/history_design_ui.dart';

class ServiceHistoryScreen extends StatefulWidget {
  @override
  State<ServiceHistoryScreen> createState() => _ServiceHistoryScreenState();
}

class _ServiceHistoryScreenState extends State<ServiceHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 72, 147, 137),
        title: const Text(
          "Service History",
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          color: Colors.white,
          onPressed: () {
            SystemNavigator.pop();
          },
        ),
      ),
      body: ListView.separated(
        separatorBuilder: (context, i) => const Divider(
          color: Colors.white,
          thickness: 1,
          height: 1,
        ),
        itemBuilder: (context, i) {
          return Card(
            color: Colors.grey,
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
