import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class InfoDesignUI extends StatefulWidget {
  String? textInfo;
  IconData? iconData;
  InfoDesignUI({this.textInfo, this.iconData});

  @override
  State<InfoDesignUI> createState() => _InfoDesignUIState();
}

class _InfoDesignUIState extends State<InfoDesignUI> {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Color.fromARGB(255, 146, 201, 193),
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      child: ListTile(
        leading: Icon(
          widget.iconData,
          color: const Color.fromARGB(255, 72, 147, 137),
        ),
        title: Text(
          widget.textInfo!,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
