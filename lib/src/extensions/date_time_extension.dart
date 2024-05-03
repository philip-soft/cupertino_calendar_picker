extension PackageDateTimeExtension on DateTime {
  DateTime addDays(int days) {
    return DateTime.utc(year, month, day + days);
  }
}
