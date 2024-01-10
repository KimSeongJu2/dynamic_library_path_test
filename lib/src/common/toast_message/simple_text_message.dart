import 'package:flutter/material.dart';

class SimpleTextMessage extends StatelessWidget {
  final String text;

  const SimpleTextMessage({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 134, 129, 129).withOpacity(0.4),
          borderRadius: BorderRadius.circular(13),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    );
  }
}
