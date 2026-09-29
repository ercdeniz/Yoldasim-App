// Aktivite Tipleri

import 'package:flutter/material.dart';

enum ActivityType { salah, fasting, dhikr, quran }

// Namaz Vakitleri
enum SalahTime { fajr, dhuhr, asr, maghrib, isha, witr }

// Zaman Periyotları
enum ActivityPeriod { daily, weekly, monthly, yearly }

// Kur'an Hedef Tipleri
enum QuranTargetType { page, juz, surah }

// Alan Zorunluluk Durumu (0: Opsiyonel, 1: Zorunlu)
enum FieldRequirement { optional, mandatory }

// Hedef Koşulları (En az, Tam, En fazla)
enum TargetCondition { atLeast, exact, atMost }

// Koşullar için uzantı metotları
extension TargetConditionExtension on TargetCondition {
  String get getText => switch (this) {
    TargetCondition.atLeast => 'En az',
    TargetCondition.exact => 'Tam Olarak',
    TargetCondition.atMost => 'En fazla',
  };

  bool checkCompletion({required int done, required int target}) {
    return switch (this) {
      TargetCondition.atLeast => done >= target,
      TargetCondition.exact   => done == target,
      TargetCondition.atMost  => done <= target && done > 0,
    };
  }
}

// Aktivite Durumları
enum ActivityStatus { pending, completed, failed }

// Aktivite Durumları için uzantı metotları
extension ActivityStatusColor on ActivityStatus {
  Color get color {
    return switch (this) {
      ActivityStatus.completed => Colors.green,
      ActivityStatus.pending => Colors.orange,
      ActivityStatus.failed => Colors.red,
    };
  }

  Color get bgColor {
    return switch (this) {
      ActivityStatus.pending => Colors.transparent,
      _ => color.withValues(alpha: 0.2),
    };
  }

  IconData get icon {
    return switch (this) {
      ActivityStatus.completed => Icons.check,
      ActivityStatus.pending => Icons.more_horiz,
      ActivityStatus.failed => Icons.close,
    };
  }
}
