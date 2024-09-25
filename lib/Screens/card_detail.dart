import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:todo/Screens/Home.dart';
import 'package:todo/Screens/Notifications/notification.dart';
import 'package:todo/provider/Theme_changer.dart';

class Details extends StatefulWidget {
  final String title;
  final String subtitle;
  final String time;
  final String date;
  String id ;
  final int iconCodePoint;
  final bool isComplete ;
  final String priority ;
  int notificationId ;
  Details({
    super.key,
    required this.date,
    required this.subtitle,
    required this.time,
    required this.title,
    required this.id,
    required this.iconCodePoint,
    required this.isComplete ,
    required this.priority,
    required this.notificationId,
  });

  @override
  State<Details> createState() => _DetailsState();
}
final unique = GlobalKey<FormState>();
TextEditingController edit_title = TextEditingController();
TextEditingController edit_description = TextEditingController();

final edit_ref = FirebaseFirestore.instance.collection('Task');
class _DetailsState extends State<Details> {
   
   


   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(onPressed: (){
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Home(),));
        }, icon: const Icon(Icons.close)),
      ),
     body: Column(
  children: [
    Expanded(
      child: ListView(
        children: [
         Consumer<ThemeProvider>(
          builder: (context, valu, child) {
           return  ListTile(
            title: Text(widget.title, style:  TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
            decoration:widget.isComplete
                ? TextDecoration.lineThrough 
                : TextDecoration.none,
            decorationThickness: 2,
            )),
            subtitle: Text(widget.subtitle, style: TextStyle(fontSize: 16, color: valu.isDarkMode? Colors.white: Colors.grey.shade700,
             decoration:widget.isComplete
                ? TextDecoration.lineThrough 
                : TextDecoration.none,
            decorationThickness: 1,
            )),
            trailing: const Icon(CupertinoIcons.pencil,size: 31,),
          );
 
         },),
       const Gap(21),
          ListTile(
            leading: const Icon(Icons.alarm),
            title: const Text('Task time', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
            trailing: Container(
              height: 51,
              width: 101,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(widget.time, textAlign: TextAlign.center ,style:  const TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),),),
            ),
          ),
          ListTile(
            leading: const Icon(CupertinoIcons.tag),
            title: const Text('Task Category : ', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
            trailing: Container(
              height: 35,
              width: 91,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: widget.iconCodePoint != null ? Icon(IconData(widget.iconCodePoint, fontFamily: 'CupertinoIcons', fontPackage: 'cupertino_icons'), color: Colors.blue.shade300, size: 23,weight: 5,) : const Text('null'),),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.flag_outlined),
            title: const Text('Task Priority : ', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),),
            trailing: Container(
              height: 35,
              width: 91,
              decoration: BoxDecoration(
                color: Colors.grey.shade700,
                borderRadius: BorderRadius.circular(10),
              ),
              child:  Center(child: Text(widget.priority, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),),),
            ),
          ),
          ListTile(
            onTap: () {
              _build_Show_Dialouge();
            },
            leading: const Icon(Icons.delete, color: Colors.red,),
            title: const Text('Delete Task', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.red),),
          ),
        ],
      ),
    ),
  
   
  widget.isComplete? Text('') : GestureDetector(
    onTap: (){
        ShowMydialog(context,widget.title,widget.subtitle,widget.id);
    },
     child: Container(
      height: 51,
      width: 351,
      decoration: BoxDecoration(
        color: Colors.deepPurple,
       
        borderRadius: BorderRadius.circular(5),
     
            ),
            child: const Center(child: Text('Edit Task',style: TextStyle(color: Colors.white),),),
     ),
   ),
    const Gap(21)
  ],
),   );
  }
_build_Show_Dialouge(){
return showDialog(context: context, builder: (context) {
  return AlertDialog(
    title: const Text('Delete Task'),
content: SizedBox(
  height: 51,
  child: Center(child: Text('Are You sure you want to delete this task?Task title :${widget.title}'),),
),
actions: [
TextButton(onPressed: (){
Navigator.pop(context);
}, child: const Text('Cancle')),

ElevatedButton(
  onPressed: (){
 edit_ref.doc(widget.id).delete().then((value) {
  Notification_Service.cancelNotification(widget.notificationId);
   Fluttertoast.showToast(
      msg: "Task Deleted",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Home(),),(Route<dynamic> route) => false,);
 },).onError((error, stackTrace) {
   Fluttertoast.showToast(
      msg: error.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );
 },);
}, child: const Text('Delete'))
],
  );
},);
}

Future<void> ShowMydialog(BuildContext context,String title , String description , String id) async{
edit_title.text=title ;
edit_description.text=description ;

    await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task title'),
          
          content: SingleChildScrollView(
            child: Form(
              key: unique,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: edit_title,
                    decoration: const InputDecoration(
                      hintText: 'Title',
                      border: OutlineInputBorder(),
                      
                    ),
                     validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null; 
                  },
                  ),
                  const Gap(11),
                  TextFormField(
                    controller: edit_description,
                    decoration: const InputDecoration(
                      hintText: 'Description',
                      border: OutlineInputBorder()
                    ),
                     validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a description';
                    }
                    return null; 
                  },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(); 
              },
              child: const Text('Cancel'),
            ),
          
            ElevatedButton(
              onPressed: () {
                if (unique.currentState?.validate() ?? false) {
                  edit_ref.doc(id).update({
                  'title': edit_title.text,
                  'description': edit_description.text,
                }).then((value) {
                   Navigator.of(context).pop(); 
                 Fluttertoast.showToast(msg: 'Task updated');
                },).onError((error, stackTrace) {
                  Fluttertoast.showToast(msg: error.toString());
                },);
               
              }
               
              },
              child: const Text('Edit'),
            ),
          ],
        );
      },
    );
     }



}
