import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo/Screens/Home.dart';
import 'package:todo/Screens/task_card.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
 
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


  DateTime _selectedDate = DateTime.now();
  bool showCompletedTasks = false;
  final ref = FirebaseFirestore.instance.collection('Task');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Home(),
              ),
            );
          },
          icon: Icon(Icons.close),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
           
            Container(
              height: 151,
              color: Colors.grey.shade700,
              child: PageView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 12,
                itemBuilder: (context, index) {
                  return TableCalendar(
  firstDay: DateTime.now(),
  lastDay: DateTime(2095),
  focusedDay: _selectedDate,
  calendarFormat: CalendarFormat.week,
  calendarStyle: CalendarStyle(
    defaultTextStyle: TextStyle(color: Colors.white),
   weekendTextStyle: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),
   
  ),
 headerStyle: HeaderStyle(
    formatButtonTextStyle: TextStyle(fontSize: 15.0, color: Colors.white),
    leftChevronIcon: Icon(Icons.chevron_left,color: Colors.white,),
    rightChevronIcon: Icon(Icons.chevron_right,color: Colors.white),
    titleCentered: true,
    titleTextStyle: TextStyle(color: Colors.white),
    
    formatButtonDecoration: BoxDecoration(
     
      borderRadius: BorderRadius.circular(16.0),
    ),
  ),
  selectedDayPredicate: (day) {
    return isSameDay(_selectedDate, day);
  },
  onDaySelected: (selectedDay, focusedDay) {
    setState(() {
      _selectedDate = selectedDay;
    });
  },
  daysOfWeekStyle: DaysOfWeekStyle(weekdayStyle: TextStyle(color: Colors.white),weekendStyle: TextStyle(color: Colors.red),
  ),
  calendarBuilders: CalendarBuilders(
    selectedBuilder: (context, date, events) => Container(
      margin: const EdgeInsets.all(4.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.green, // change the background color of the selected date
        shape: BoxShape.circle,
      ),
      child: Text(
        date.day.toString(),
        style: TextStyle(color: Colors.white),
      ),
    ),
    
    todayBuilder: (context, date, events) => Container(
      margin: const EdgeInsets.all(4.0),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blue, // change the background color of today's date
        shape: BoxShape.circle,
      ),
      child: Text(
        date.day.toString(),
        style: TextStyle(color: Colors.white),
      ),
    ),
  ),
);
                },
              ),
            ),
        Gap(21),
            // Buttons to toggle between Today and Completed
            Container(
              width: 381,
              height: 101,
             decoration: BoxDecoration(
               color: Colors.grey.shade700,
               borderRadius: BorderRadius.circular(5)
             ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: (){
                       setState(() {
                        showCompletedTasks = false;
                     });
                    },
                    child: Container(
                      height: 51,
                      width:151 ,
                      decoration: BoxDecoration(
                        color: showCompletedTasks ? Colors.transparent:Colors.deepPurple,
                        border: Border.all(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(child: Text('Today',style: TextStyle(color: Colors.white),),),
                    ),
                  ),
                  InkWell(
                    onTap: (){
                       setState(() {
                       showCompletedTasks = true;
                     });
                    },
                    child: Container(
                      height: 51,
                      width:151 ,
                      decoration: BoxDecoration(
                        color: showCompletedTasks ? Colors.deepPurple : Colors.transparent,
                        border: Border.all(
                          color: Colors.white
                        ),
                        borderRadius: BorderRadius.circular(5)
                      ),
                      child: Center(child: Text('Completed',style: TextStyle(color: Colors.white),),),
                    ),
                  )
                  
            
                ],
              ),
            ),
           Gap(11),
            
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 13 ),
                child: StreamBuilder<QuerySnapshot>(
                  stream:ref.where('doc_id', isEqualTo: auth.currentUser!.uid).snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator(color: Colors.purple,));
                    }
                        
                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No tasks available'));
                    }
                        
                    // Extract tasks from Firestore
                    var allTasks = snapshot.data!.docs;
                        
                    // Filter tasks based on the selected date or completed status
                    var filteredTasks = allTasks.where((task) {
                      // Parse date from Firestore
                      var taskDate = DateTime.tryParse(task['date']);
                      
                      bool isToday = taskDate != null &&
                          taskDate.year == _selectedDate.year &&
                          taskDate.month == _selectedDate.month &&
                          taskDate.day == _selectedDate.day;
                        
                      if (showCompletedTasks) {
                        return task['completed'] == true;
                      } else {
                        return isToday && task['completed'] == false;
                      }
                    }).toList();
                         filteredTasks.sort((a, b) {
                      DateTime timeA = combineDateTime(
                          _selectedDate, a['time']); 
                      DateTime timeB = combineDateTime(
                          _selectedDate, b['time']);
                      return timeA.compareTo(timeB);
                    });
                    if (filteredTasks.isEmpty) {
                      return Center(child: Text('No tasks found for the selected criteria'));
                    }
                        
                    return ListView.builder(
                      itemCount: filteredTasks.length,
                      itemBuilder: (context, index) {
                        var task = filteredTasks[index];
                        return TaskCard(
                          title: task['title'],
                          description: task['description'],
                          time: task['time'],
                          iconCodePoint: task['icon'],
                          isCompleted: task['completed'],
                          id: task.id,
                          priority: task['priority'].toString(),
                        );
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

