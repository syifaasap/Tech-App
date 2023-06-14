import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:tech_app/Models/service_history_model.dart';

class HistoryDesignUIWidget extends StatefulWidget {
  ServiceHistoryModel? serviceHistoryModel;

  HistoryDesignUIWidget({this.serviceHistoryModel});

  @override
  State<HistoryDesignUIWidget> createState() => _HistoryDesignUIWidgetState();
}

class _HistoryDesignUIWidgetState extends State<HistoryDesignUIWidget> {
  String formatDateAndTime(String dateTimeFromDB) {
    DateTime dateTime = DateTime.parse(dateTimeFromDB);

    // Dec 10                                     //2022                                  //1:12 pm
    String formattedDatetime =
        "${DateFormat.MMMd().format(dateTime)}, ${DateFormat.y().format(dateTime)} - ${DateFormat.jm().format(dateTime)}";

    return formattedDatetime;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Technician name + Fare Amount
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5.0),
                  child: Text(
                    "User : " + widget.serviceHistoryModel!.userName!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 72, 147, 137),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  "Rp " + widget.serviceHistoryModel!.fareAmount!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 10,
            ),

            // phone details
            Row(
              children: [
                const Icon(
                  Icons.phone_android_rounded,
                  color: Colors.grey,
                  size: 28,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  widget.serviceHistoryModel!.userPhone!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            //icon + pickup
            Row(
              children: [
                Image.asset(
                  "assets/images/origin.png",
                  height: 26,
                  width: 26,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      widget.serviceHistoryModel!.originAddress!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 14,
            ),

            //icon + dropOff
            Row(
              children: [
                Image.asset(
                  "assets/images/destination.png",
                  height: 24,
                  width: 24,
                ),
                const SizedBox(
                  width: 12,
                ),
                Expanded(
                  child: Container(
                    child: Text(
                      widget.serviceHistoryModel!.destinationAddress!,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 14,
            ),

            //service time and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDateAndTime(widget.serviceHistoryModel!.time!),
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }
}
