import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

Future<({TimeOfDay start, TimeOfDay end})?> pickTimeRange(BuildContext context) async {
  TimeOfDay? startTime = await showTimePicker(
    helpText: "اختيار وقت البداية",
    context: context,
    initialTime: TimeOfDay.now(),
  );

  if (startTime == null) {
    return null;
  }

  TimeOfDay? endTime = await showTimePicker(
    context: context,
    helpText: "اختيار وقت النهاية",
    initialTime: TimeOfDay.now(),
  );
  if (endTime == null) {
    return null;
  }

  return (start: startTime, end: endTime);
}

Future<DateTime?> pickDate(BuildContext context) async {
  DateTime? picked = await showDatePicker(
    context: context,
    firstDate: DateTime(DateTime.now().year - 5),
    lastDate: DateTime(DateTime.now().year + 5),
    initialDate: DateTime.now(),
  );
  return picked;
}

Future<TimeOfDay?> pickTime(BuildContext context) async {
  TimeOfDay? picked = await showTimePicker(
    context: context,
    initialTime: TimeOfDay.now(),
  );
  return picked;
}

String formatDate(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

String formatTime(TimeOfDay time) {
  return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
}
