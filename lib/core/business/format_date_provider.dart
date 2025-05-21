import 'package:intl/intl.dart';

class FormatDateProvider{
  static String formatYMMMd(String? rawDate) {
    if(rawDate == null) {
      return '';
    }
    final parsedDate = DateTime.parse(rawDate); // Parse from 'yyyy-MM-dd'
    final formatter = DateFormat('MMMM d, y');  // Format to 'May 20, 2025'
    return formatter.format(parsedDate);
  }

  static String formatMonthDay(String? rawDate) {
    if(rawDate == null) {
      return '';
    }
    final parsedDate = DateTime.parse(rawDate);
    final formatter = DateFormat('MMM d');
    return formatter.format(parsedDate);
  }

  static String formatWeekday(String? rawDate) {
    if (rawDate == null) {
      return '';
    }
    final parsedDate = DateTime.parse(rawDate);
    final formatter = DateFormat('E'); // 'E' cho Mon, Tue, Wed,...
    return formatter.format(parsedDate); // => 'Tue'
  }

}