extension PackageDateTimeExtension on DateTime {
  DateTime addDays(int days) {
    return DateTime.utc(year, month, day + days);
  }

  DateTime truncateToMinutes({int? newHour, int? newMinute}) {
    return DateTime(year, month, day, newHour ?? hour, newMinute ?? minute);
  }
}
