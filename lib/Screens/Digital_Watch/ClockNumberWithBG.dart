import 'package:flutter/material.dart';
import 'package:todo/Screens/Digital_Watch/DigitalNumber.dart';

class ClockNumberWithBG extends StatelessWidget {
  final double height;

  final int value;

  const ClockNumberWithBG(
      {super.key, required this.height, required this.value});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        DigitalNumber(
          value: value,
          height: height * 0.4,
          color: Colors.black,
        ),
        DigitalNumber(
          value: 8,
          height: height * 0.4,
          color: Colors.black12,
        ),
      ],
    );
  }
}

