import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:todo/Screens/Notifications/notification.dart';


class NotificationUtils {
  static String formatDateTime(String date, String time) {
    DateTime selectedDate = DateTime.parse(date);
    DateTime today = DateTime.now();
    if (selectedDate.year == today.year &&
        selectedDate.month == today.month &&
        selectedDate.day == today.day) {
      return 'Today at: $time';
    } else {
      return '${DateFormat('EEE, MMM d').format(selectedDate)} at: $time';
    }
  }

  static Future<void> scheduleNotificationFromData(String date, String time, String title, String description) async {
    try {
      DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm");
      DateTime dateTime = dateFormat.parse("$date $time");
      tz.TZDateTime scheduleDateTZ = tz.TZDateTime.from(dateTime, tz.local);

      if (scheduleDateTZ.isBefore(DateTime.now())) {
        print("Scheduled time is in the past. Adjusting to future.");
        scheduleDateTZ = scheduleDateTZ.add(Duration(days: 1));
      }

      int notificationId = dateTime.millisecondsSinceEpoch.remainder(1000000);
      await Notification_Service.scheduleNotification(notificationId, title, description, scheduleDateTZ);
      print("Notification scheduled successfully for $scheduleDateTZ");
    } catch (e) {
      print("Error scheduling notification: $e");
    }
  }
}
