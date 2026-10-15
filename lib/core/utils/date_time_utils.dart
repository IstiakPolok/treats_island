import 'package:intl/intl.dart';

/// Centralized utility for handling date/time parsing and formatting in the user's local timezone.
class DateTimeUtils {
  DateTimeUtils._();

  /// Parses any datetime representation from the API (ISO-8601, SQL datetime string, etc.)
  /// into the device's LOCAL timezone.
  ///
  /// If the incoming string lacks 'Z' or a timezone offset (+HH:MM / -HH:MM),
  /// it normalizes it with 'Z' so that Dart treats it as UTC, then converts to the user's local timezone.
  static DateTime? parseToLocal(dynamic rawDate) {
    if (rawDate == null) return null;
    if (rawDate is DateTime) return rawDate.toLocal();

    String str = rawDate.toString().trim();
    if (str.isEmpty || str == 'null') return null;

    // Replace whitespace with 'T' if format is "YYYY-MM-DD HH:MM:SS"
    if (str.contains(' ') && !str.contains('T')) {
      str = str.replaceFirst(' ', 'T');
    }

    // Check if timezone indicator already exists
    final bool hasZ = str.endsWith('Z') || str.endsWith('z');
    final bool hasOffset = RegExp(r'[+-]\d{2}:?\d{2}$').hasMatch(str);

    if (!hasZ && !hasOffset) {
      // Force UTC interpretation by appending 'Z'
      str = '${str}Z';
    }

    try {
      final parsed = DateTime.parse(str);
      return parsed.toLocal();
    } catch (_) {
      try {
        final parsed = DateTime.tryParse(rawDate.toString().trim());
        return parsed?.toLocal();
      } catch (_) {
        return null;
      }
    }
  }

  /// Formats date into a readable string in the viewer's local timezone.
  /// Example default: "Monday, October 20, 2026"
  static String formatLocalDate(
    dynamic rawDate, {
    String pattern = 'EEEE, MMMM dd, yyyy',
    String fallback = '',
  }) {
    final local = parseToLocal(rawDate);
    if (local == null) return fallback;
    return DateFormat(pattern).format(local);
  }

  /// Returns a clean timezone label (e.g. "PDT", "EDT", "GMT+6", "GMT-7").
  static String getTimeZoneLabel(DateTime date) {
    final tz = date.timeZoneName.trim();
    if (tz.isEmpty) {
      final offset = date.timeZoneOffset;
      final sign = offset.isNegative ? '-' : '+';
      final hours = offset.inHours.abs();
      return 'GMT$sign$hours';
    }
    // If tz is already a standard abbreviation like PDT, PST, EDT, BST, UTC
    if (RegExp(r'^[A-Za-z]{2,5}$').hasMatch(tz)) {
      return tz;
    }
    // If tz is a raw offset string like "+06", "+06:00", "+6", "-07"
    if (RegExp(r'^[+-]\d+').hasMatch(tz)) {
      final sign = tz.startsWith('-') ? '-' : '+';
      final digits = tz.replaceAll(RegExp(r'[^0-9]'), '');
      final hours = int.tryParse(digits.length >= 2 ? digits.substring(0, 2) : digits) ?? 0;
      return 'GMT$sign$hours';
    }
    return tz;
  }

  /// Formats time in the viewer's local timezone.
  /// If [withTimezone] is true, appends the local timezone (e.g. "10:00 am (EDT)", "10:00 am (GMT+6)").
  static String formatLocalTime(
    dynamic rawDate, {
    String pattern = 'h:mm a',
    bool withTimezone = true,
    bool toLowerCase = true,
    String fallback = '',
  }) {
    final local = parseToLocal(rawDate);
    if (local == null) return fallback;

    String formatted = DateFormat(pattern).format(local);
    if (toLowerCase) {
      formatted = formatted.toLowerCase();
    }

    if (withTimezone) {
      final tz = getTimeZoneLabel(local);
      if (tz.isNotEmpty) {
        formatted = '$formatted ($tz)';
      }
    }

    return formatted;
  }

  /// Formats date range in the viewer's local timezone.
  /// Example: "Oct 15 - Oct 20"
  static String formatLocalDateRange(
    dynamic rawStart,
    dynamic rawEnd, {
    String pattern = 'MMM d',
    String fallback = 'No Date Added',
  }) {
    final start = parseToLocal(rawStart);
    final end = parseToLocal(rawEnd);

    if (start != null && end != null) {
      return '${DateFormat(pattern).format(start)} - ${DateFormat(pattern).format(end)}';
    } else if (start != null) {
      return DateFormat(pattern).format(start);
    }
    return fallback;
  }

  /// Returns the current device local timezone abbreviation (e.g. "EDT", "PDT", "GMT+6").
  static String get localTimeZoneName => DateTime.now().timeZoneName;
}
