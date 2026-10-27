import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._();

  static String note(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final diff = today.difference(day).inDays;

    if (diff == 0) return 'Today, ${DateFormat('h:mm a').format(date)}';
    if (diff == 1) return 'Yesterday';
    if (date.year == now.year) return DateFormat('MMM d').format(date);
    return DateFormat('MMM d, y').format(date);
  }
}