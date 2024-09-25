import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:todo/Screens/App_Info/About.dart';
import 'package:todo/Screens/Home.dart';
import 'package:todo/Screens/Notifications/notification.dart';
import 'package:todo/Screens/Reset_passoward/Reset.dart';
import 'package:todo/onBoarding/Onboarding.dart';
import 'package:avatar_glow/avatar_glow.dart';
class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance.currentUser;
    final String? userEmail = auth?.email;
     final auth1 = FirebaseAuth.instance;
    final Currentuser = FirebaseAuth.instance;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home(),)) ;
        }, icon: const Icon(Icons.close)),
        title: const Text('Profile', style:  TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
         crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Gap(35),
            Center(
              child: AvatarGlow(
              startDelay: const Duration(milliseconds: 1000),
              glowColor: Colors.deepPurple.shade500,
              glowShape: BoxShape.circle,
              animate: true,
              repeat: true,
              curve: Curves.linear,
              child: const Material(
                elevation: 3.0,
                shape: CircleBorder(),
                color: Colors.transparent,
                child: CircleAvatar(
                  backgroundImage: AssetImage('Assets/images/pro.png',),
                 
                  radius: 47.0,
                ),
              ),
                            )
            ),
            const Gap(11),
            StreamBuilder(
            stream: FirebaseFirestore
            .instance
            .collection('Task')
            .where('doc_id',isEqualTo: Currentuser.currentUser!.uid).snapshots(),
             builder:(context, snapshot) {
               return Text(userEmail.toString(), style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 17),);
             }, ),
             const Gap(11),
             _buildList(const Icon(Icons.key_outlined),const Text('Change account passoward'), const Icon(Icons.chevron_right),ontap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword(),));
             }),
             _buildList(const Icon(Icons.gif_box),const Text('about us'), const Icon(Icons.chevron_right),ontap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const About(),));
             }),
             _buildList(const Icon(Icons.logout,color: Colors.red,),const Text('Log out',style: TextStyle(color: Colors.red),), const Icon(Icons.chevron_right),
             ontap: (){
               auth1.signOut().then((value) {
                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Onboarding(),),(Route<dynamic> route) => false,);
                   Fluttertoast.showToast(
                msg: 'Log out successfully',
                backgroundColor: Colors.green,
                gravity: ToastGravity.BOTTOM,
                textColor: Colors.white
               );
               Notification_Service.cancelAllNotifications();
               },).onError((error, stackTrace) {
               Fluttertoast.showToast(
                msg: 'Error : ${error.toString()}',
                backgroundColor: Colors.red,
                gravity: ToastGravity.BOTTOM,
                textColor: Colors.white
               );
               },);
             }),
          ],
        ),
      ),
    );
  }

  _buildList(Icon icon1 , Text title , Icon icon2 , {ontap} ){

   return  ListTile(
           onTap: ontap,
            leading:icon1,
            title: title,
            trailing: icon2,
           );

  }

}