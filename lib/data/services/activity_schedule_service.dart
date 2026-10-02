import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/date_extensions.dart';
import 'package:yoldasim_app/data/models/activity_model.dart';

/// Periot aralığı için başlangıç ve bitiş tarihlerini temsil eden sınıf.
class ActivityPeriodRange {
  final DateTime start;
  final DateTime end;

  const ActivityPeriodRange({required this.start, required this.end});
}

/// Bu servis, aktivitelerin belirli bir tarihte planlanıp planlanmadığını kontrol eder.
class ActivityScheduleService {
  ActivityScheduleService._();

  /// Belirli bir tarihte bir aktivitenin planlanıp planlanmadığını kontrol eder.
  static bool isScheduledOnDate(ActivityModel activity, DateTime date) {
    final targetDate = date.onlyDate;
    if (targetDate.isBefore(activity.startDate.onlyDate)) {
      return false;
    }

    final schedule = activity.schedule;
    switch (activity.period) {
      case ActivityPeriod.daily:
        return true;
      case ActivityPeriod.weekly:
        final weeklyDays = schedule.weeklyDays;
        return weeklyDays.isEmpty || weeklyDays.contains(targetDate.weekday);
      case ActivityPeriod.monthly:
        final monthlyDays = schedule.monthlyDays;
        return monthlyDays.isEmpty || monthlyDays.contains(targetDate.day);
      case ActivityPeriod.yearly:
        return true;
      case ActivityPeriod.allTime:
        return true;
    }
  }

  /// Belirli bir periyot ve tarihe göre aktivitenin geçerli tarih aralığını döndürür.
  static ActivityPeriodRange periodRange(ActivityPeriod period, DateTime date) {
    final targetDate = date.onlyDate;

    switch (period) {
      case ActivityPeriod.daily:
        return ActivityPeriodRange(
          start: targetDate,
          end: targetDate.add(const Duration(days: 1)),
        );
      case ActivityPeriod.weekly:
        final start = targetDate.subtract(
          Duration(days: targetDate.weekday - DateTime.monday),
        );
        return ActivityPeriodRange(
          start: start,
          end: start.add(const Duration(days: 7)),
        );
      case ActivityPeriod.monthly:
        final start = DateTime(targetDate.year, targetDate.month);
        return ActivityPeriodRange(
          start: start,
          end: DateTime(targetDate.year, targetDate.month + 1),
        );
      case ActivityPeriod.yearly:
        final start = DateTime(targetDate.year);
        return ActivityPeriodRange(
          start: start,
          end: DateTime(targetDate.year + 1),
        );
      case ActivityPeriod.allTime:
        return ActivityPeriodRange(
          start: DateTime.fromMillisecondsSinceEpoch(0),
          end: DateTime(9999, 12, 31),
        );
    }
  }
}
