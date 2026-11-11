import 'package:intl/intl.dart';

class AppDateTime {
  AppDateTime._();

  static DateTime get _now => DateTime.now();

  static String get day => DateFormat('EEE').format(_now);

  static String get checkInApi => DateFormat('yyyy-MM-dd').format(_now);

  static String get checkOutApi =>
      DateFormat('yyyy-MM-dd').format(_now.add(const Duration(hours: 24)));

  static String get checkInUi => DateFormat('dd MMM').format(_now);

  static String get checkOutUi =>
      DateFormat('dd MMM').format(_now.add(const Duration(hours: 24)));

  static String formatIsoDateTime(String isoDate) {
    final date = DateTime.parse(isoDate).toLocal();
    return DateFormat('dd MMM yyyy, h:mm a').format(date);
  }

  static Map<String, String> get bookingDates => {
    'check_in': checkInApi,
    'check_out': checkOutApi,
  };

  static String toApiFormat(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);

  static String toUiFormat(DateTime date) => DateFormat('dd MMM').format(date);

  static String get cartDateRange {
    final checkIn = _now;
    final checkOut = checkIn.add(const Duration(hours: 24));

    if (checkIn.month == checkOut.month) {
      return '${DateFormat('MMM').format(checkIn)} '
          '${checkIn.day} - ${checkOut.day}';
    }

    return '${DateFormat('MMM').format(checkIn)} ${checkIn.day} - '
        '${DateFormat('MMM').format(checkOut)} ${checkOut.day}';
  }
}
