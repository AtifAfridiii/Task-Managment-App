import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo/Screens/Notifications/notification.dart';
import 'package:todo/provider/CategoryProvider.dart';
import 'package:todo/provider/Circular_Indicator.dart';
import 'package:todo/provider/NavigationProvider.dart';
import 'package:todo/provider/Theme_changer.dart';
import 'package:todo/provider/board.dart';
import 'package:todo/provider/clock.dart';
import 'package:todo/provider/focus.dart';
import 'package:todo/provider/selectedIcon.dart';
import 'package:todo/provider/visivble_passoward.dart';
import 'package:todo/splashScreen/splash.dart';
import 'firebase_options.dart';
import 'package:timezone/data/latest.dart' as tz;
void main() async{
WidgetsFlutterBinding.ensureInitialized();
await Notification_Service.init();
tz.initializeTimeZones();

await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
);

  runApp(
    
    const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

 
  @override
  Widget build(BuildContext context) {
  return MultiProvider(providers: [
ChangeNotifierProvider(create: (_) => Board()),
ChangeNotifierProvider(create: (_) => SelectTime()),
ChangeNotifierProvider(create: (_) => SelectedIcon()),
ChangeNotifierProvider(create: (_) => TimerService()),
ChangeNotifierProvider(create: (_) => Visible_Passoward()),
ChangeNotifierProvider(create: (_) => ThemeProvider()),
ChangeNotifierProvider(create: (_) => CategoryProvider()),
ChangeNotifierProvider(create: (_) => NavigationProvider()), 
ChangeNotifierProvider(create: (_) => Circular_provider()),
    ],
    child: Builder(
        builder: (BuildContext context) {
         final themeProvider = Provider.of<ThemeProvider>(context);
          return Consumer<ThemeProvider>(
            builder: (context, value, child) {
              return MaterialApp(
  title: 'Flutter Demo',
  theme: ThemeData.light(
    useMaterial3: true
  ),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
  builder: (context, child) {
    return CupertinoTheme(
      data: const CupertinoThemeData(),
      child: Material(child: child),
    );
  },
  home: const Splash(),
);
            },
          );
        },
      ),
    
   ); }
}

 