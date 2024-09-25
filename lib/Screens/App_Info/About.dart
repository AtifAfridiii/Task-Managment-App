import 'package:flutter/material.dart';
import 'package:todo/Screens/Home.dart';

class About extends StatelessWidget {
  const About({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text('About us',style: TextStyle(fontWeight: FontWeight.bold),),
        centerTitle: true,
        leading: IconButton(
          onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => const Home(),));
        }, icon: const Icon(Icons.close)),
      ),
      body: const SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: Column(
              children: [
               Text.rich(
                  TextSpan(
                    text: '',
                    style: TextStyle(fontSize: 16,),
                    children: [
                     
                      TextSpan(
                        text: 'Overview:\n',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            'Welcome to Todo, your ultimate task management companion designed to help you stay organized and productive. Whether you\'re managing daily chores, work projects, or personal goals, Todo ensures that you never miss a deadline. With its intuitive interface and powerful features, Todo makes it easy to add, track, and complete tasks efficiently.\n\n',
                      ),
                      TextSpan(
                        text: 'Key Features:\n\n',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text: 'Task Creation:\n',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            '- Easily add tasks with just a few taps.\n- Include detailed descriptions, due dates, and priority levels for each task.\n- Categorize tasks into different lists or projects for better organization.\n\n',
                      ),
                      TextSpan(
                        text: 'Reminders and Notifications:\n',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            '- Set reminders for each task to receive timely notifications.\n- Choose the exact date and time for notifications to ensure you never forget an important task.\n- Customizable notification settings to suit your preferences.\n\n',
                      ),
                      TextSpan(
                        text: 'Task Management:\n',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            '- Mark tasks as complete with a simple swipe.\n- Archive completed tasks to keep your active list clutter-free.\n- Edit or delete tasks as needed.\n\n',
                      ),
                      TextSpan(
                        text: 'User-Friendly Interface:\n',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            '- Clean and intuitive design for a seamless user experience.\n- Easy navigation between different sections of the app.\n- Customizable themes and layouts to personalize your Todo experience.\n\n',
                      ),
                      TextSpan(
                        text: 'Sync Across Devices:\n',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            '- Automatically sync your tasks across all your devices.\n- Access your to-do list from your smartphone, tablet, or computer.\n- Stay organized no matter where you are.\n\n',
                      ),
                      TextSpan(
                        text: 'Collaboration (Optional):\n',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            '- Share task lists with friends, family, or colleagues.\n- Assign tasks to others and track progress in real-time.\n- Foster teamwork and accountability.\n\n',
                      ),
                      TextSpan(
                        text: 'Why Choose Todo?\n',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            'Efficiency: Stay on top of your tasks with timely reminders and a clear overview of your to-do list.\n'
                            'Flexibility: Customize your task management experience to fit your unique needs and preferences.\n'
                            'Reliability: Count on Todo to keep you organized and help you achieve your goals.\n\n',
                      ),
                      TextSpan(
                        text: 'Join the Todo Community:\n',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      TextSpan(
                        text:
                            'Download Todo today and take the first step towards a more organized and productive life. Whether you\'re a busy professional, a student, or someone looking to manage daily tasks more effectively, Todo is here to support you every step of the way.',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}