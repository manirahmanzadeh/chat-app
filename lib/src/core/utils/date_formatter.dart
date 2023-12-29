import 'package:intl/intl.dart';

String formatDateTime(DateTime dateTime) {
  DateTime now = DateTime.now();
  DateTime yesterday = DateTime(now.year, now.month, now.day - 1);

  if (dateTime.isAfter(now.subtract(const Duration(days: 1)))) {
    // Today
    return DateFormat.jm().format(dateTime); // 4:33 PM
  } else if (dateTime.isAfter(yesterday.subtract(const Duration(days: 1)))) {
    // Yesterday
    return 'Yesterday';
  } else {
    // Older than yesterday
    return DateFormat('dd, MMM').format(dateTime); // 25, Jun
  }
}
