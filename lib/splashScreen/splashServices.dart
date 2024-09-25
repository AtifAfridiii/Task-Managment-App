import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/Screens/Home.dart';
import 'package:todo/onBoarding/Onboarding.dart';

class Splashservices {


void IsLogin(BuildContext context){

FirebaseAuth auth = FirebaseAuth.instance;

final User = auth.currentUser;

if(User!=null){
Timer(const Duration(seconds: 2),() {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home(),));
},);
}else{

Timer(const Duration(seconds: 2),() {
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) =>  const Onboarding(),));
},);



}




}



}