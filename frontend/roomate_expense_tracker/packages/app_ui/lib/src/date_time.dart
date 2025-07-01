import 'package:intl/intl.dart';

final currentDate = DateTime(
  DateTime.now().year,
  DateTime.now().month,
  DateTime.now().day,
);

class DateFormatter {
  static String formatTimestamp(DateTime dateTime) {
    // Convert Timestamp to DateTime
    // final dateTime = timestamp.toDate();

    // Define the format
    final dateFormat = DateFormat('MMMM dd, yyyy');

    // Format the DateTime to a String
    return dateFormat.format(dateTime);
  }
}
