

import 'package:flutter/material.dart';
import 'package:todo/Screens/Digital_Watch/DigitalClock.dart';


class NeoDigitalScreen extends StatelessWidget {
  const NeoDigitalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(
          color: const Color.fromRGBO(217, 230, 243, 1),
          borderRadius: BorderRadius.circular(15),
          boxShadow: const [
            BoxShadow(
                color: Colors.white, offset: Offset(-15, -15), blurRadius: 15),
            BoxShadow(
                color: Color.fromRGBO(214, 223, 230, 1),
                offset: Offset(20, 20),
                blurRadius: 15)
          ]),
      child: Center(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Container(
                height: constraints.maxHeight * 0.9,
                width: constraints.maxWidth * 0.95,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                        color: const Color.fromRGBO(160, 168, 168, 1),
                        width: 2),
                    gradient: const LinearGradient(colors: [
                      Color.fromRGBO(203, 211, 196, 1),
                      Color.fromRGBO(176, 188, 165, 1)
                    ])),
                child: Center(
                  child: DigitalClock(
                    maxHeight: constraints.maxHeight,
                    maxWidth: constraints.maxWidth,
                  ),
                ));
          },
        ),
      ),
    );
  }
}

