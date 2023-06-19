import 'package:flutter/material.dart';

class MyProgressDialog extends StatelessWidget {
  String? message;
  MyProgressDialog({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.grey.shade300,
      child: Container(
        margin: const EdgeInsets.all(5),
        // decoration: BoxDecoration(
        //   color: const Color.fromARGB(255, 24, 75, 69),
        //   borderRadius: BorderRadius.circular(10),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const SizedBox(
                width: 10,
              ),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.grey.shade600,
                ),
              ),
              const SizedBox(
                width: 26,
              ),
              Text(
                message!,
                style: TextStyle(
                    color: Colors.grey.shade600,
                    fontFamily: "PTSans",
                    fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
