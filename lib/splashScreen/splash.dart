import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:todo/splashScreen/splashServices.dart';

class Splash extends StatefulWidget {
   const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}



class _SplashState extends State<Splash> {
Splashservices services = Splashservices();
@override
  void initState() {
    services.IsLogin(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
     body:Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
         Lottie.asset('animation/todo.json',
         animate: true,
         repeat: true,
         fit: BoxFit.cover,
        reverse: true
         ),
      ],
     )
    );
  }
}