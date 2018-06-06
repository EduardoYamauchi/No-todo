import 'package:intl/intl.dart';

String dateFormatted() {
  var now = DateTime.now();

  var formatted = new DateFormat("EEE, MM d, ''yy");
  String formatter = formatted.format(now);

  return formatter;
}