import 'package:intl/intl.dart';

class DateUtilsHelper {
  /// Converts ISO datetime string to `dd-MM-yyyy`
  static String formatPlacedAt(String isoDate) {
    try {
      final DateTime parsed = DateTime.parse(isoDate);
      return DateFormat('dd-MM-yyyy').format(parsed.toLocal());
    } catch (e) {
      return isoDate; // fallback if parsing fails
    }
  }
}