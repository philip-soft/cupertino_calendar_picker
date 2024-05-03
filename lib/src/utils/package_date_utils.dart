abstract final class PackageDateUtils {
  static DateTime monthDateOnly(DateTime date) {
    return DateTime(date.year, date.month);
  }
}
