import 'package:flutter/material.dart';

class InfoDesignUI extends StatefulWidget {
  String? textInfo;
  IconData? iconData;
  InfoDesignUI({super.key, this.textInfo, this.iconData});

  @override
  State<InfoDesignUI> createState() => _InfoDesignUIState();
}

class _InfoDesignUIState extends State<InfoDesignUI> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[200],
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
      child: ListTile(
        leading: Icon(
          widget.iconData,
          color: const Color.fromARGB(255, 56, 120, 240),
        ),
        title: Text(
          widget.textInfo!,
          style: const TextStyle(
            color: Color.fromARGB(255, 35, 53, 88),
            fontSize: 20,
            fontFamily: "PTSans",
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
