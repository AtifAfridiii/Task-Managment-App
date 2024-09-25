import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Screens/Digital_Watch/ClockNumberWithBG.dart';
import 'package:todo/Screens/Digital_Watch/DigitalColon.dart';
import 'package:todo/provider/focus.dart';

class DigitalClock extends StatelessWidget {
  final double maxHeight;
  final double maxWidth;

  const DigitalClock({
    super.key,
    required this.maxHeight,
    required this.maxWidth,
  });

  @override
  Widget build(BuildContext context) {
    final duration = Provider.of<TimerService>(context).currentDuration;

    final hours = createNumberTime(duration.inHours);
    final minutes = createNumberTime(duration.inMinutes);
    final seconds = createNumberTime(duration.inSeconds);

    return Container(
        height: maxHeight * 0.5,
        width: maxWidth * 0.7,
        decoration: const BoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ...hours,
            DigitalColon(
              height: maxHeight * 0.3,
              color: Colors.black87,
            ),
            ...minutes,
            DigitalColon(
              height: maxHeight * 0.3,
              color: Colors.black87,
            ),
            ...seconds
          ],
        ));
  }

  List<ClockNumberWithBG> createNumberTime(int numberTime) {
    final int parsedNumber = numberTime % 60;
    final bool isTwoDigit = parsedNumber.toString().length == 2;
    final int firstDigit =
        isTwoDigit ? int.parse(parsedNumber.toString()[0]) : 0;
    final int secondDigit =
        isTwoDigit ? int.parse(parsedNumber.toString()[1]) : numberTime % 60;

    return [
      ClockNumberWithBG(
        height: maxHeight,
        value: firstDigit,
      ),
      ClockNumberWithBG(
        height: maxHeight,
        value: secondDigit,
      )
    ];
  }
}

