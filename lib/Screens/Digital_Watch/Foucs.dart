
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo/Screens/Digital_Watch/CenterProgressPie.dart';
import 'package:todo/Screens/Digital_Watch/NeoDigitalScreen.dart';
import 'package:todo/Screens/Digital_Watch/NeumorphicResetBtn.dart';
import 'package:todo/Screens/Home.dart';
import 'package:todo/provider/Theme_changer.dart';
import 'package:todo/provider/focus.dart';

class Digi_Watch extends StatelessWidget {
  const Digi_Watch({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TimerService>(
      create: (_) => TimerService(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(onPressed: (){
           Navigator.push(context, MaterialPageRoute(builder: (context) => const Home(),));
          }, icon: const Icon(Icons.close)),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              Consumer<ThemeProvider>(
                builder: (context, value, child) {
                return Row(
                children: [
                  Text(
                    "Focus Mode",
                    style: TextStyle(
                        fontSize: 25,
                        color:value.isDarkMode? Colors.white: Color.fromRGBO(49, 68, 105, 1),
                        fontWeight: FontWeight.bold),
                  ),
                ],
              );
              },),
              const Spacer(),
              const NeoDigitalScreen(),
              const Spacer(),
              const CenterProgressPie(),
              const Spacer(),
              const Spacer(),
              NeumorphicResetBtn(
                color: Theme.of(context).primaryColor,
                child: const Center(
                  child: Text(
                    "RESET",
                    style: TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w700),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// class NeumorphicHumburgerBtn extends StatefulWidget {
//   const NeumorphicHumburgerBtn({super.key});

//   @override
//   _NeumorphicHumburgerBtnState createState() => _NeumorphicHumburgerBtnState();
// }

// class _NeumorphicHumburgerBtnState extends State<NeumorphicHumburgerBtn> {
//   bool _isPressed = false;

//   void _onPointerDown(PointerDownEvent event) {
//     setState(() {
//       _isPressed = true;
//     });
//   }

//   void _onPointerUp(PointerUpEvent event) {
//     setState(() {
//       _isPressed = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Listener(
//       onPointerDown: _onPointerDown,
//       onPointerUp: _onPointerUp,
//       child: AnimatedContainer(
//         duration: const Duration(milliseconds: 50),
//         height: 50,
//         width: 50,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: Theme.of(context).primaryColor,
//           gradient: LinearGradient(
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//             colors: _isPressed
//                 ? [
//                     Colors.white,
//                     const Color.fromRGBO(214, 223, 230, 1),
//                   ]
//                 : [
//                     Theme.of(context).primaryColor,
//                     Theme.of(context).primaryColor,
//                   ],
//           ),
//           boxShadow: _isPressed
//               ? null
//               : const [
//                   BoxShadow(
//                     blurRadius: 10,
//                     offset: Offset(-5, -5),
//                     color: Colors.white,
//                   ),
//                   BoxShadow(
//                       blurRadius: 10,
//                       offset: Offset(5, 5),
//                       color: Color.fromRGBO(214, 223, 230, 1))
//                 ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             for (int i = 0; i < 3; i++) ...[
//               Container(
//                 height: 3,
//                 width: 25,
//                 margin: EdgeInsets.only(top: i == 0 ? 0 : 4),
//                 decoration: const BoxDecoration(
//                     color: Color.fromRGBO(214, 223, 230, 1)),
//               )
//             ]
//           ],
//         ),
//       ),
//     );
//   }
// }

