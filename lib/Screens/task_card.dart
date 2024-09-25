import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:todo/Screens/Home.dart';
import 'package:todo/provider/Theme_changer.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final int iconCodePoint;
  final bool isCompleted;
  final String id;
  final String priority ;
  const TaskCard({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.iconCodePoint,
    required this.isCompleted,
    required this.id,
    required this.priority
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Consumer<ThemeProvider>(
        builder: (context, val, child) {
        return Card(
        color:val.isDarkMode?  const Color(0xff547d5b) : const Color(0xffe2dfd2),
        child: Column(
          children: [
            ListTile(
              leading: Checkbox(
                 activeColor: Colors.amber,
                value: isCompleted,
                
                onChanged: (bool? value) async {
                  try {
                    // Update Firestore with the new "completed" value
                    await FirebaseFirestore.instance
                        .collection('Task')
                        .doc(id)
                        .update({'completed': value});
                  
                    // // Show a SnackBar to confirm the action
                      Fluttertoast.showToast(msg: value == true
                            ? 'Task marked as completed'
                            : 'Task marked as incompleted',
                            backgroundColor:value==true? Colors.green:Colors.red,
                            gravity: ToastGravity.BOTTOM
                            );
                  } catch (e) {
                    print('Error updating task: $e');
                  Fluttertoast.showToast(msg: "Error:${e.toString()}",
                            backgroundColor:Colors.red,
                            gravity: ToastGravity.BOTTOM
                            );
                  }
                },
              ),
              title: Text(
                title,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  decoration:
                      isCompleted ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
              subtitle: Text(description),
              
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 19,vertical: 9),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                   Container(
                              height: 21,
                              width: 61,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(
                                  255,
                                  101 + random.nextInt(56),
                                  101 + random.nextInt(56),
                                  101 + random.nextInt(56),
                                ),
                                borderRadius: BorderRadius.circular(3),
                              ),
                              child: Center(
                                child: Text(priority,style: const TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),)
                              ),
                            ),
                    const Gap(11),
                  Container(
                  width: 45,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                      color:Color.fromARGB(
                                  255,
                                  101 + random.nextInt(56),
                                  101 + random.nextInt(56),
                                  101 + random.nextInt(56),
                                ),
                  ),
                  child: Icon(IconData(iconCodePoint,
                    fontFamily: 'CupertinoIcons', fontPackage: 'cupertino_icons'),color: Colors.white,),
                )
                ],
              ),
            )
          ],
        ),
      );
   
      },)
       );
  }
}
