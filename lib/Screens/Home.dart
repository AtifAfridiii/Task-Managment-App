import 'dart:math';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:todo/Screens/Category.dart';
import 'package:todo/Screens/Digital_Watch/Foucs.dart';
import 'package:todo/Screens/Notifications/notification.dart';
import 'package:todo/Screens/Profile.dart';
import 'package:todo/Screens/calender.dart';
import 'package:todo/Screens/card_detail.dart';
import 'package:todo/component/CustomPaint.dart';
import 'package:todo/component/Navbar.dart';
import 'package:todo/component/Search.dart';
import 'package:todo/onBoarding/Onboarding.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/provider/CategoryProvider.dart';
import 'package:todo/provider/NavigationProvider.dart';
import 'package:todo/provider/Theme_changer.dart';
import 'package:todo/provider/clock.dart';
class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}


TextEditingController title = TextEditingController();
TextEditingController description = TextEditingController();
TextEditingController edit_title = TextEditingController();
TextEditingController edit_description = TextEditingController();

FirebaseAuth auth = FirebaseAuth.instance;
final auth1 = FirebaseAuth.instance.currentUser;
 final String? userEmail = auth1?.email;
final firestore = FirebaseFirestore.instance.collection('Task');
final ref = FirebaseFirestore.instance.collection('Task');
String userid =  FirebaseFirestore.instance.collection('Task').doc().id;
final edit_ref = FirebaseFirestore.instance.collection('Task');
String? _userSelectedTime;
IconData? _selectedIcon;
final search_Controller= TextEditingController();
String hint = 'Search';
Random random = Random();
String selectedPriority = '';
 String selectedFilter = 'Recent';

class _HomeState extends State<Home> {
Widget _buildHeader() {
  return Consumer<ThemeProvider>(
    builder: (context, valie, child) {
    return DrawerHeader(
    decoration: BoxDecoration(color: valie.isDarkMode? Color(0xff708985) : Color(0xff1D1E22)),
    child: Column(
      children: [
        CircleAvatar(
          backgroundImage: AssetImage('Assets/images/pro.png'),
          radius: 40,
        ),
        Gap(21),
        if (auth.currentUser != null) 
          StreamBuilder(
            stream: FirebaseFirestore
                .instance
                .collection('Task')
                .where('doc_id', isEqualTo: auth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              return Text(
                userEmail.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.white,
                ),
              );
            },
          )
        else 
          Text(
            'Please log in',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: Colors.white,
            ),
          ),
      ],
    ),
  );

  },);
  }
 Widget _buildItem(
      {required IconData icon,
      required String title,
      required GestureTapCallback onTap}) {
    return ListTile(
      leading: Icon(icon,),
      title: Text(title),
      onTap: onTap,
      minLeadingWidth: 5,
    );
  }
final _formkey = GlobalKey<FormState>();
  _buildCategory(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(11),
              const Text('Choose Category', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
              const SizedBox(
                width: 251,
                child: Divider(color: Colors.black, thickness: 1),
              ),
              const Gap(17),
              Consumer<CategoryProvider>(
                builder: (context, categoryProvider, child) {
                  return ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.5,
                    ),
                    child: MasonryGridView.builder(
                      shrinkWrap: true,
                      gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                      ),
                      itemCount: categoryProvider.categories.length + 1, // +1 for the "add" button
                      itemBuilder: (context, index) {
                        if (index == categoryProvider.categories.length) {
                          // This is the "add" button
                          return _buildCategoryItem(
                            icon: CupertinoIcons.add,
                            onTap: () async {
                              final result = await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => const CreateCategory()),
                              );
                              if (result != null && result is Map<String, dynamic>) {
                                categoryProvider.addCategory(result);
                                Navigator.pop(context); // Close the dialog
                                _buildCategory(context); // Reopen the dialog to show the new category
                              }
                            },
                          );
                        } else {
                          // This is a category item
                          return _buildCategoryItem(
                            icon: categoryProvider.categories[index]['icon'],
                            onTap: () {
                              // Handle category selection
                              Navigator.pop(context);
                            },
                          );
                        }
                      },
                    ),
                  );
                },
              ),
              const Gap(15),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              const Gap(15),
            ],
          ),
        ),
      );
    },
  );
}  
Widget _buildCategoryItem({required IconData icon, required VoidCallback onTap}) {
  Random random = Random();
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: GestureDetector(
        onTap: () {
          _selectedIcon = icon; 
          onTap();
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          height: 75,
          color: Color.fromARGB(
            255,
            101 + random.nextInt(56),
            101 + random.nextInt(56),
            101 + random.nextInt(56),
          ),
          child: Center(child: Icon(icon, color: Colors.white)),
        ),
      ),
    ),
  );
}  // Track selected index


  // Update index when an item is tapped
 void _onNavBarItemTapped(BuildContext context, int index) {
  final navigationProvider = Provider.of<NavigationProvider>(context, listen: false);
  navigationProvider.selectIndex(index);

  // Navigate to different pages based on the tapped index
  switch (index) {
    case 0:
      // Handle the case for index 0, if needed
      break;
    case 1:
      Navigator.push(context, MaterialPageRoute(builder: (context) => TaskScreen()));
      break;
    case 2:
      Navigator.push(context, MaterialPageRoute(builder: (context) => const Digi_Watch()));
      break;
    case 3:
      Navigator.push(context, MaterialPageRoute(builder: (context) => Profile()));
      break;
  }
}
 
late final ValueNotifier<DateTime> _selectedDate;
  late SelectTime _timeprov;
   
List<bool> isCheckedList = [];

late int notification ;


 DateTime combineDateTime(DateTime date, String timeString) {
    final timeParts = timeString.split(' ');
    final hourMinuteParts = timeParts[0].split(':');
    int hour = int.parse(hourMinuteParts[0]);
    int minute = int.parse(hourMinuteParts[1]);
    final isPm = timeParts[1].toLowerCase() == 'pm';

    if (isPm && hour != 12) {
      hour += 12;
    } else if (!isPm && hour == 12) {
      hour = 0;
    }

    return DateTime(
      date.year,
      date.month,
      date.day,
      hour,
      minute,
    );
  }

  String formatDateTime(String date, String time) {
    DateTime selectedDate = DateTime.parse(date);
    DateTime today = DateTime.now();

    if (selectedDate.year == today.year &&
        selectedDate.month == today.month &&
        selectedDate.day == today.day) {
      return 'Today at: $time';
    } else {
      return '${DateFormat('EEE').format(selectedDate)} at: $time';
    }
  }
  @override
  void initState() {
    super.initState();
    _selectedDate = ValueNotifier(DateTime.now());
    _timeprov = SelectTime();
  }




  @override
  void dispose() {
    _selectedDate.dispose();
    _timeprov.dispose();
    super.dispose();
  }
    @override
  Widget build(BuildContext context) {

 

    Size size = MediaQuery.of(context).size;
    double height = 56;

    const primaryColor = Colors.amber;
    const secondaryColor = Colors.black54;
    const backgroundColor = Color.fromARGB(255, 195, 181, 181);
 
    return Scaffold(
      appBar: AppBar(
        title: Text('Index',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
           
           Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11),
        child: PrimaryContainer(
          child: TextField(
            onChanged: (value) {
              setState(() {
                
              });
            },
            style: const TextStyle(fontSize: 16, color: Colors.white),
            textAlignVertical: TextAlignVertical.center,
            controller: search_Controller,
            decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.only(left: 20, right: 20, bottom: 3),
                border: InputBorder.none,
                filled: false,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                hintText: 'Search',
                suffixIcon: Container(
                  width: 70,
                  decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [
                        Color(0XFF5E5E5E),
                        Color(0XFF3E3E3E),
                      ], begin: Alignment.centerLeft, end: Alignment.centerRight),
                      borderRadius: BorderRadius.circular(30)),
                  child: const Icon(Icons.search, color: Color(0xFF222222)),
                ),
                hintStyle: const TextStyle(fontSize: 14, color: Colors.grey)),
          ),
        ),
            ),
         Gap(21),
      
Padding(
  padding: const EdgeInsets.only(left:19),
  child: Container(
    height: 51,
    width: 131,
    decoration: BoxDecoration(
      color: Colors.deepPurple.shade900,
      borderRadius: BorderRadius.circular(11),
    ),
    child: Center(
      child: DropdownButton<String>(
        value: selectedFilter,
         dropdownColor: Colors.grey.shade900,
        style: TextStyle(color: Colors.white),
        underline: Container(), 
        iconEnabledColor: Colors.white,
        items: <String>['Recent', 'High', 'Medium', 'Low']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Center(child: Text(value)),
          );
        }).toList(),
        onChanged: (String? newValue) {
          setState(() {
            selectedFilter = newValue!;
          });
        },
      ),
    ),
  ),
),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(7),
              child: StreamBuilder<QuerySnapshot>(
                stream:auth.currentUser != null
      ? ref.where('doc_id', isEqualTo: auth.currentUser!.uid).snapshots()
      : null,
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    int count = (snapshot.hasData) ? snapshot.data!.docs.length : 5;
                    return _build_shimmer(count);
                  }
              
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Some error occurred'),
                    );
                  }
              
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
              Center(child: Image.asset('Assets/images/task.png')),
              const Gap(11),
              const Text(
                'What do you want to do today?',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              ),
              const Gap(5),
              const Text('Tap + to add your tasks'),
                      ],
                    );
                  }
                   
             var sortedTasks = snapshot.data!.docs;

// Apply filtering based on selected filter
if (selectedFilter == 'High') {
  sortedTasks = sortedTasks.where((task) => task['priority'] == 'High').toList();
} else if (selectedFilter == 'Medium') {
  sortedTasks = sortedTasks.where((task) => task['priority'] == 'Medium').toList();
} else if (selectedFilter == 'Low') {
  sortedTasks = sortedTasks.where((task) => task['priority'] == 'Low').toList();
}

// Sort by date and time
sortedTasks.sort((a, b) {
  DateTime dateA = DateTime.parse(a['date']);
  DateTime dateB = DateTime.parse(b['date']);
  DateTime combinedA = combineDateTime(dateA, a['time']);
  DateTime combinedB = combineDateTime(dateB, b['time']);
  return combinedB.compareTo(combinedA); // Sort by latest first
});

              
                  return ListView.builder(
                    itemCount: sortedTasks.length,
                    shrinkWrap: true,
                    
                    itemBuilder: (context, index) {
                     var task = sortedTasks[index];
                      String title = task['title'].toString();
                      String description = task['description'].toString();
                      String id = task['id'].toString();
                      int icon = task['icon'];
                      String time = task['time'].toString();
                      String date = task['date'].toString();
                      bool isCompleted = task['completed'] ?? false; 
                      String formattedTime = formatDateTime(date, time);
                      String Title = task['title'].toString(); 
                      String priority = task['priority'].toString();
                      int notification_id = task['notification_Id'];
                      
                        if(search_Controller.text.isEmpty){
                          return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Details(
                      title: title,
                      subtitle: description,
                      time: formattedTime,
                      date: date,
                      id: id,
                      iconCodePoint: icon,
                      isComplete: isCompleted,
                      priority: priority,
                      notificationId: notification_id,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child:Consumer<ThemeProvider>(
                  builder: (context, valii, child) {
                  return  Card( 
                  color:valii.isDarkMode? Color(0xff547d5b) : const Color(0xffe2dfd2),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Checkbox(
                          visualDensity: const VisualDensity(
                            horizontal: VisualDensity.maximumDensity,
                            vertical: VisualDensity.maximumDensity,
                          ),
                          value: isCompleted,
                          onChanged: (bool? value) {
                          
                            ref.doc(task.id).update({'completed': value});
                
                            setState(() {
                              isCompleted = value ?? false;
                            });
                          },
                         
                          activeColor: Colors.amber,
                          side: BorderSide(
                            color: isCompleted ? Colors.white : Colors.black,
                            width: 2.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        title: Text(
                          title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                                decorationThickness: 3
                          ),
                        ),
                        subtitle: Text(description,style: TextStyle(
                         
                             decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                                decorationThickness: 3
                        ),),
                        trailing:isCompleted
                                ? null : PopupMenuButton(
  icon: Icon(Icons.more_vert, color: valii.isDarkMode ? Colors.white : Colors.black),
  itemBuilder: (context) => [
    PopupMenuItem(
      value: 1,
      child: Builder(
        builder: (newContext) {
          return ListTile(
            onTap: () {
              Navigator.of(newContext, rootNavigator: true).pop();
              ShowMydialog(title, description, id);
            },
            title: const Text('Edit'),
            leading: const Icon(Icons.edit),
          );
        },
      ),
    ),
    PopupMenuItem(
      value: 2,
      child: Builder(
        builder: (newContext) {
          return ListTile(
            onTap: () {
              Navigator.of(newContext, rootNavigator: true).pop();
              edit_ref.doc(id).delete().then((value) {
                Notification_Service.cancelNotification(notification_id);
                Fluttertoast.showToast(
                  msg: "Task Deleted",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }).onError((error, stackTrace) {
                Fluttertoast.showToast(
                  msg: error.toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              });
            },
            title: const Text('Delete'),
            leading: const Icon(Icons.delete),
          );
        },
      ),
    ),
  ],
)                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
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
                                child: Text(priority,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),)
                              ),
                            ),
                            Gap(11),
                            Container(
                              height: 21,
                              width: 41,
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
                                child: Icon(
                                  IconData(icon,
                                      fontFamily: 'CupertinoIcons',
                                      fontPackage: 'cupertino_icons'),
                                  color: Colors.white,
                                  size: 19,
                                  weight: 5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(11),
                    ],
                  ),
                );
  
                },)            ),
                      );
             
                        }else if(Title.toLowerCase().contains(search_Controller.text.toString().toLowerCase())){
        
                          return InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Details(
                      title: title,
                      subtitle: description,
                      time: formattedTime,
                      date: date,
                      id: id,
                      iconCodePoint: icon,
                      isComplete: isCompleted,
                      priority: priority, 
                      notificationId: notification_id,
                    ),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(5),
                child:Consumer<ThemeProvider>(
                  builder: (context, valii, child) {
                  return  Card( 
                  color:valii.isDarkMode? Color(0xff547d5b) : const Color(0xffe2dfd2),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Checkbox(
                          visualDensity: const VisualDensity(
                            horizontal: VisualDensity.maximumDensity,
                            vertical: VisualDensity.maximumDensity,
                          ),
                          value: isCompleted,
                          onChanged: (bool? value) {
                          
                            ref.doc(task.id).update({'completed': value});
                
                            setState(() {
                              isCompleted = value ?? false;
                            });
                          },
                         
                          activeColor: Colors.amber,
                          side: BorderSide(
                            color: isCompleted ? Colors.white : Colors.black,
                            width: 2.0,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0),
                          ),
                        ),
                        title: Text(
                          title,
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                                decorationThickness: 3
                          ),
                        ),
                        subtitle: Text(description,style: TextStyle(
                         
                             decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                                decorationThickness: 3
                        ),),
                        trailing:isCompleted
                                ? null :PopupMenuButton(
  icon: Icon(Icons.more_vert, color: valii.isDarkMode ? Colors.white : Colors.black),
  itemBuilder: (context) => [
    PopupMenuItem(
      value: 1,
      child: Builder(
        builder: (newContext) {
          return ListTile(
            onTap: () {
              Navigator.of(newContext, rootNavigator: true).pop();
              ShowMydialog(title, description, id);
            },
            title: const Text('Edit'),
            leading: const Icon(Icons.edit),
          );
        },
      ),
    ),
    PopupMenuItem(
      value: 2,
      child: Builder(
        builder: (newContext) {
          return ListTile(
            onTap: () {
              Navigator.of(newContext, rootNavigator: true).pop();
              edit_ref.doc(id).delete().then((value) {
                Notification_Service.cancelNotification(notification_id);
                Fluttertoast.showToast(
                  msg: "Task Deleted",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }).onError((error, stackTrace) {
                Fluttertoast.showToast(
                  msg: error.toString(),
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              });
            },
            title: const Text('Delete'),
            leading: const Icon(Icons.delete),
          );
        },
      ),
    ),
  ],
)                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
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
                                child: Text(priority,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,),)
                              ),
                            ),
                            Gap(11),
                            Container(
                              height: 21,
                              width: 41,
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
                                child: Icon(
                                  IconData(icon,
                                      fontFamily: 'CupertinoIcons',
                                      fontPackage: 'cupertino_icons'),
                                  color: Colors.white,
                                  size: 19,
                                  weight: 5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Gap(11),
                    ],
                  ),
                );
  
                },)            ),
                    );
                
                        }else{
                          return Center(child: Text(''));
                        }
        
                         },
                  );
                },
              ),
            )
           )
          
          ],
        ),
      ),
      drawer:  Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(),
          _buildItem(
            icon: CupertinoIcons.home,
            title: 'Home',
            onTap: () => {
              Navigator.pop(context),
            },
          ),
          _buildItem(
            icon: CupertinoIcons.person,
            title: 'Profile',
            onTap: () => {
              Navigator.push(context, MaterialPageRoute(builder: (context) => Profile(),))
            },
          ),
        Consumer<ThemeProvider>(
  builder: (context, themeProvider, child) {
   
    bool isDarkMode = themeProvider.isDarkMode;
    
    return ListTile(
      leading: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
      trailing: Switch(
        value: isDarkMode,
        onChanged: (bool value) {
          
          themeProvider.toggleTheme();
        },
      ),
    );
  },
),

          _buildItem(
            icon: Icons.logout_rounded,
            title: 'Log out',
            onTap: () => {
         auth.signOut().then((value) {
                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const Onboarding(),), (Route<dynamic> route) => false,);
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
               },)
            },
          )
        ],
      ),
    ),
      bottomNavigationBar: BottomAppBar(
      color: Colors.transparent,
      elevation: 0,
      child: Stack(
        children: [
          CustomPaint(
            size: Size(size.width, height + 7),
            painter: BottomNavCurvePainter(backgroundColor: backgroundColor),
          ),
          Center(
            heightFactor: 0.6,
            child: FloatingActionButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100.0)),
              backgroundColor: Colors.deepPurple,
              elevation: 0.1,
              onPressed: () {
                  _ShowBottomSheet(context);
                },
              child: const Icon(
                CupertinoIcons.add,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(
            height: height,
            child:Consumer<NavigationProvider>(
        builder: (context, navigationProvider, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              NavBarIcon(
                text: "Home",
                icon: CupertinoIcons.home,
                selected: navigationProvider.selectedIndex == 0,
                onPressed: () => _onNavBarItemTapped(context, 0),
                defaultColor: secondaryColor,
                selectedColor: primaryColor,
              ),
              NavBarIcon(
                text: "Calendar",
                icon: CupertinoIcons.calendar,
                selected: navigationProvider.selectedIndex == 1,
                onPressed: () => _onNavBarItemTapped(context, 1),
                defaultColor: secondaryColor,
                selectedColor: primaryColor,
              ),
              const SizedBox(width: 56),
              NavBarIcon(
                text: "Focus",
                icon: CupertinoIcons.clock,
                selected: navigationProvider.selectedIndex == 2,
                onPressed: () => _onNavBarItemTapped(context, 2),
                defaultColor: secondaryColor,
                selectedColor: primaryColor,
              ),
              NavBarIcon(
                text: "Profile",
                icon: CupertinoIcons.person,
                selected: navigationProvider.selectedIndex == 3,
                onPressed: () => _onNavBarItemTapped(context, 3),
                selectedColor: primaryColor,
                defaultColor: secondaryColor,
              ),
            ],
          );
        },
      ),
          ),
        ],
      ),
    ),
    );
    
  }

Future<void> _ShowBottomSheet(BuildContext context){
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true, 
    builder: (context) {  
      return Form(
        key: _formkey,
        child: DraggableScrollableSheet(
          expand: false,
          builder: (context, scrollController) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: SingleChildScrollView(
                controller: scrollController,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 21),
                  child: Column(
                    mainAxisSize: MainAxisSize.min, 
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Align(
                        alignment: FractionalOffset(0.05, 0),
                        child: Text(
                          "Add Task",
                          style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                        ),
                      ),
                      const Gap(11),
                      TextFormField(
                        controller: title,
                        decoration: const InputDecoration(
                          hintText: 'Title',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                 if (value == null || value.isEmpty) {
                return 'Please write your title';
              }
              return null;
              }
                      ),
                      const Gap(21),
                      TextFormField(
                        controller: description,
                        decoration: const InputDecoration(
                          hintText: 'Description',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please write a description';
              }
              return null;
                        }
                      ),
                      const Gap(11),
                      Row(
                        children: [
                          IconButton(
                           onPressed: () {
                          _selectDate();
          },
                            icon: const Icon(CupertinoIcons.alarm),
                          ),
                          IconButton(
                            onPressed: () {
                              _buildCategory(context);
                            },
                            icon: const Icon(CupertinoIcons.tag),
                          ),
                          IconButton(
                            onPressed: () {
                               _showPriorityDialog(context);
                            },
                            icon: const Icon(CupertinoIcons.flag),
                          ),
                          const Spacer(), 

                       Consumer<SelectTime>(
      builder: (context, vali, child) {
        return IconButton(
          onPressed: () async {
            if (_formkey.currentState!.validate()) {
              
               if (selectedPriority.isEmpty) {
                selectedPriority = 'Default';
                             }
               
              if (_userSelectedTime != null && _selectedIcon != null) {
                Navigator.pop(context);
                String id = DateTime.now().microsecondsSinceEpoch.toString();
                int notificationIdCounter =random.nextInt(100000);
                print("Notification Id : $notificationIdCounter");
                try {
                  await firestore.doc(id).set({
                    'title': title.text.toString(),
                    'description': description.text.toString(),
                    'date': _selectedDate.value.toIso8601String(),
                    'time': _userSelectedTime,
                    'id': id,
                    'doc_id': auth.currentUser!.uid,
                    'icon': _selectedIcon!.codePoint,
                    'priority': selectedPriority,
                    'completed': false,
                    'notification_Id': notificationIdCounter
                  });

                  DateTime scheduledDateTime = combineDateTime(_selectedDate.value, _userSelectedTime!);
                  
                  if (scheduledDateTime.isAfter(DateTime.now())) {
                    await Notification_Service.scheduleNotification(
                      notificationIdCounter++,
                      "Reminder: ${title.text.toString()}",
                       "It's time to complete your task",
                      scheduledDateTime,
                    );
                    Fluttertoast.showToast(
                      msg: "Task added",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  } else {
                    Fluttertoast.showToast(
                      msg: "You will not get notification because \n Scheduled time is in the past",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0,
                    );
                  }

                  title.clear();
                  description.clear();
                  vali.reset();
                  _userSelectedTime = null;
                  _selectedIcon = null;
                  selectedPriority = '';
                } catch (error) {
                  print('Error saving to Firestore or scheduling notification: $error');
                  Fluttertoast.showToast(
                    msg: "Error occurred: $error",
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }
              } else {
                Fluttertoast.showToast(
                  msg: "Please select a date||time & Category",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  backgroundColor: Colors.red,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
              }
            }
          },
          icon: const Icon(Icons.send, color: Colors.deepPurple),
        );
      },
    )                 ])
                ])
              ),
            ));
          },
        ),
      );
    },
    showDragHandle: true,
  );
}

Future<void> _showPriorityDialog(BuildContext context) {
  bool isHigh = false;
  bool isMedium = false;
  bool isLow = false;

  return showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Select Priority"),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CheckboxListTile(
                  title: Text("High"),
                  value: isHigh,
                  onChanged: (value) {
                    setState(() {
                      isHigh = value!;
                      if (isHigh) {
                        selectedPriority = 'High';
                        isMedium = false;
                        isLow = false;
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Medium"),
                  value: isMedium,
                  onChanged: (value) {
                    setState(() {
                      isMedium = value!;
                      if (isMedium) {
                        selectedPriority = 'Medium';
                        isHigh = false;
                        isLow = false;
                      }
                    });
                  },
                ),
                CheckboxListTile(
                  title: Text("Low"),
                  value: isLow,
                  onChanged: (value) {
                    setState(() {
                      isLow = value!;
                      if (isLow) {
                        selectedPriority = 'Low';
                        isHigh = false;
                        isMedium = false;
                      }
                    });
                  },
                ),
              ],
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (selectedPriority.isEmpty) {
                selectedPriority = 'Default';
              }
              Navigator.pop(context); 
            },
            child: Text("Save"),
          ),
        ],
      );
    },
  );
}

Future<void> ShowMydialog(String title , String description , String id) async{
edit_title.text=title ;
edit_description.text=description ;

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Task'),
          content: SingleChildScrollView(
            child: Form(
              key: _formkey,
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
                Navigator.pop(context); 
              },
              child: const Text('Cancel'),
            ),
          
            ElevatedButton(
              onPressed: () {
                if (_formkey.currentState?.validate() ?? false) {
                   Navigator.pop(context);
                  edit_ref.doc(id).update({
                  'title': edit_title.text,
                  'description': edit_description.text,
                }).then((value) {
                  
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Task updated',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                  // behavior: SnackBarBehavior.floating,
                  // backgroundColor: Colors.green,
                  // ),
                  
                  // );
                },).onError((error, stackTrace) {
                  // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('$error',style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                  // behavior: SnackBarBehavior.floating,
                  // backgroundColor: Colors.red,
                  // ),
                  
                  // );
                },);
               
              }
               
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
     }



Future<void> _selectDate() async {
  await showDialog<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ValueListenableBuilder<DateTime>(
                valueListenable: _selectedDate,
                builder: (context, selectedDate, _) {
                  return TableCalendar(
                    firstDay: DateTime.now(),
                    lastDay: DateTime(2095),
                    focusedDay: selectedDate,
                    selectedDayPredicate: (day) => isSameDay(day, selectedDate),
                    onDaySelected: (selectedDay, focusedDay) {
                      _selectedDate.value = focusedDay;
                                        },
                    calendarFormat: CalendarFormat.month,
                    calendarStyle: CalendarStyle(
                      isTodayHighlighted: true,
                      canMarkersOverflow: true,
                      todayDecoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Colors.blue.shade500,
                        shape: BoxShape.circle,
                      ),
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: false,
                      titleCentered: true,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(11)),
                      titleTextStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 11),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _selectedDate.value = DateTime.now();
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _selectTime();
                    },
                    child: const Text('Choose Time'),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _selectTime() async {
  // Initialize with current time
  SelectTime currentTime = SelectTime();

  SelectTime? result = await showDialog<SelectTime>(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: StatefulBuilder(
            builder: (context, setState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Hour
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                currentTime.incrementHour();
                              });
                            },
                            icon: const Icon(CupertinoIcons.chevron_up),
                          ),
                          Text(
                            currentTime.hour.toString().padLeft(2, '0'),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                currentTime.decrementHour();
                              });
                            },
                            icon: const Icon(CupertinoIcons.chevron_down),
                          ),
                        ],
                      ),
                      // Separator
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                        child: Text(
                          ":",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      // Minute
                      Column(
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                currentTime.incrementMinute();
                              });
                            },
                            icon: const Icon(CupertinoIcons.chevron_up),
                          ),
                          Text(
                            currentTime.minute.toString().padLeft(2, '0'),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                currentTime.decrementMinute();
                              });
                            },
                            icon: const Icon(CupertinoIcons.chevron_down),
                          ),
                        ],
                      ),
                      // Period
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: [
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  currentTime.togglePeriod();
                                });
                              },
                              icon: const Icon(CupertinoIcons.chevron_up),
                            ),
                            Text(
                              currentTime.period,
                              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  currentTime.togglePeriod();
                                });
                              },
                              icon: const Icon(CupertinoIcons.chevron_down),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "${currentTime.hour.toString().padLeft(2, '0')}:${currentTime.minute.toString().padLeft(2, '0')} ${currentTime.period}",
                    style: const TextStyle(fontSize: 24, color: Colors.grey),
                  ),
                  const SizedBox(height: 21),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context, currentTime);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  )
                ],
              );
            },
          ),
        ),
      );
    },
  );

  if (result != null) {
    setState(() {
      _timeprov = result;
      _userSelectedTime = '${result.hour.toString().padLeft(2, '0')}:${result.minute.toString().padLeft(2, '0')} ${result.period}';
    });
  }
}


_build_shimmer(int count) {
    return ListView.separated(
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (context, index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[300]!,
          highlightColor: Colors.grey[100]!,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14)),
              ),
              const SizedBox(width: 20.0),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      height: 15.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      width: 200,
                      height: 15.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Container(
                      width: 120.0,
                      height: 15.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, _) => const SizedBox(height: 15),
    );
  }

 
}


