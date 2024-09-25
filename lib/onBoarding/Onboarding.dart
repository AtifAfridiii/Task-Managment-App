import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:todo/login/signup/Login.dart';
import 'package:todo/provider/board.dart';

class Onboarding extends StatefulWidget {
   const Onboarding({super.key});

  @override
  State<Onboarding> createState() => _OnboardingState();
}

class _OnboardingState extends State<Onboarding> {
final pageController = PageController();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(

body: Container(
  padding: const EdgeInsets.only(bottom: 51),

   child: Consumer<Board>(builder: (context, val, child) {
     return PageView(
       controller: pageController,
       onPageChanged: (index) {
    
     val.islastpage = index == 2;
    
       },
       
    children: [
     
     build_Image('Manage your tasks','You can easily manage all  of your daily \ntasks in DoMe for free','Assets/images/board1.png'),
     build_Image('Create daily routine','In Uptodo  you can create your personalized \n routine to stay productive','Assets/images/board2.png'),
     build_Image('Orgonaize your tasks','You can organize your daily tasks by adding your \ntasks into separate categories','Assets/images/board3.png'),
    ],
      );
   },)
   ),
  bottomSheet: Container(
    padding: const EdgeInsets.symmetric(horizontal: 21),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
   
   TextButton(
    onPressed: (){
    pageController.jumpToPage(2);
   }, child: const Text('Skip')),    

 
SmoothPageIndicator(
  controller: pageController,
   count: 3,
effect: const WormEffect(),
onDotClicked: (index) => pageController.animateToPage(index,
duration: const Duration(milliseconds: 551),
curve: Curves.linear),
),
    

Consumer<Board>(
              builder: (context, boardProvider, child) {
                return boardProvider.islastpage
                    ? ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const Login()),
                          );
                        },
                        child: const Text('Get Started'),
                      )
                    : TextButton(
                        onPressed: () {
                          pageController.nextPage(
                            duration: const Duration(milliseconds: 21),
                            curve: Curves.linear,
                          );
                        },
                        child: const Text('Next'),
                      );})    
      ],
    ),
  ),

    );
  }

  Widget build_Image(String title  , String description , String image){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        
       children: [
         Image.asset(image),
        const Gap(11),
        Text(title,style: const TextStyle(fontSize: 31,fontWeight: FontWeight.bold),),
        const Gap(11),
        Text(description)
       ],
      ),
    );
  }
}