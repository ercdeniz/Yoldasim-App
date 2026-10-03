// Aktivite Tipleri

import 'package:flutter/material.dart';
import 'package:yoldasim_app/core/constants/app_assets.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/theme/app_colors.dart';

enum ActivityType {
  salah,
  fasting,
  quran,
  dhikr;

  String get iconPath {
    switch (this) {
      case ActivityType.salah:
        return AppAssets.iconSalah;
      case ActivityType.fasting:
        return AppAssets.iconFasting;
      case ActivityType.quran:
        return AppAssets.iconQuran;
      case ActivityType.dhikr:
        return AppAssets.iconDhikr;
    }
  }

  Color get color {
    switch (this) {
      case ActivityType.salah:
        return AppColors.salahColor;
      case ActivityType.fasting:
        return AppColors.fastingColor;
      case ActivityType.quran:
        return AppColors.quranColor;
      case ActivityType.dhikr:
        return AppColors.dhikrColor;
    }
  }
}

// Namaz Vakitleri
enum SalahTime {
  fajr,
  dhuhr,
  asr,
  maghrib,
  isha,
  witr;

  String get displayName {
    switch (this) {
      case SalahTime.fajr:
        return 'Sabah Kazası';
      case SalahTime.dhuhr:
        return 'Öğle Kazası';
      case SalahTime.asr:
        return 'İkindi Kazası';
      case SalahTime.maghrib:
        return 'Akşam Kazası';
      case SalahTime.isha:
        return 'Yatsı Kazası';
      case SalahTime.witr:
        return 'Vitir Kazası';
    }
  }
}

// Zaman Periyotları
enum ActivityPeriod {
  daily,
  weekly,
  monthly,
  yearly,
  allTime;

  String get displayName {
    switch (this) {
      case ActivityPeriod.daily:
        return AppConstants.activity.periodDaily;
      case ActivityPeriod.weekly:
        return AppConstants.activity.periodWeekly;
      case ActivityPeriod.monthly:
        return AppConstants.activity.periodMonthly;
      case ActivityPeriod.yearly:
        return AppConstants.activity.periodYearly;
      case ActivityPeriod.allTime:
        return AppConstants.activity.periodAllTime;
    }
  }
}

// Kur'an Hedef Tipleri
enum QuranTargetType {
  page,
  juz,
  surah;

  String get displayName {
    switch (this) {
      case QuranTargetType.page:
        return AppConstants.activity.quranPage;
      case QuranTargetType.juz:
        return AppConstants.activity.quranJuz;
      case QuranTargetType.surah:
        return AppConstants.activity.quranSurah;
    }
  }
}

// Alan Zorunluluk Durumu (0: Opsiyonel, 1: Zorunlu)
enum FieldRequirement { optional, mandatory }

// Hedef Koşulları (En az, Tam, En fazla)
enum TargetCondition {
  atLeast,
  exact,
  atMost;

  String get displayName => switch (this) {
    TargetCondition.atLeast => 'En az',
    TargetCondition.exact => 'Tam Olarak',
    TargetCondition.atMost => 'En fazla',
  };
  bool checkCompletion({required int done, required int target}) {
    return switch (this) {
      TargetCondition.atLeast => done >= target,
      TargetCondition.exact => done == target,
      TargetCondition.atMost => done <= target && done > 0,
    };
  }
}

// Aktivite Durumları
enum ActivityStatus {
  partial,
  completed,
  failed,
  pending;

  Color get color {
    return switch (this) {
      ActivityStatus.completed => Colors.green,
      ActivityStatus.partial => Colors.orange,
      ActivityStatus.failed => Colors.red,
      ActivityStatus.pending => Colors.grey,
    };
  }

  Color get bgColor {
    return switch (this) {
      ActivityStatus.partial => Colors.transparent,
      _ => color.withValues(alpha: 0.2),
    };
  }

  IconData get icon {
    return switch (this) {
      ActivityStatus.completed => Icons.check,
      ActivityStatus.partial => Icons.more_horiz,
      ActivityStatus.failed => Icons.close,
      ActivityStatus.pending => Icons.hourglass_empty,
    };
  }
}
