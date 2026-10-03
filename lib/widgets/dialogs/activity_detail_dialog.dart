import 'package:flutter/material.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/date_extensions.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/data/models/activity_model.dart';
import 'package:yoldasim_app/widgets/carts/field_requirement_badge.dart';

typedef C = AppConstants;

/// Aktivitenin detaylarını gösteren bir dialog açar.
class ActivityDetailDialog extends StatelessWidget {
  final ActivityModel activity;
  final VoidCallback onTapUpdate;

  const ActivityDetailDialog({
    super.key,
    required this.activity,
    required this.onTapUpdate,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(activity.title)),
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: FieldRequirementBadge(
              requirement: activity.isMandatory
                  ? FieldRequirement.mandatory
                  : FieldRequirement.optional,
            ),
          ),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // GENEL DETAYLAR
            // Periyot
            _detailRow(
              context,
              C.activity.detailPeriod,
              activity.period.displayName,
            ),
            // Başlangıç tarihi
            _detailRow(
              context,
              C.activity.detailStartDate,
              activity.startDate.formattedDate,
            ),
            // ÖZEL DETAYLAR
            ..._activityDetails(context),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            // Kapat Butonu - Arka plansız, oldukça sade ve dinamik genişlikte
            Expanded(
              child: TextButton(
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: context.onSurface.withValues(alpha: 0.6),
                ),
                child: Text(C.common.close),
              ),
            ),

            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  onTapUpdate();
                },
                style: FilledButton.styleFrom(
                  backgroundColor: context.primary,
                  shape: StadiumBorder(),
                ),
                child: Text(C.common.update),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Detay sayfasında gösterilecek aktiviteye özel detayları döndürür.
  List<Widget> _activityDetails(BuildContext context) {
    switch (activity.type) {
      case ActivityType.salah:
        final details = activity.salahDetails!;
        return [
          // Vakit ismi
          _detailRow(
            context,
            C.activity.detailPrayerTime,
            details.salahTime.displayName,
          ),
          // Günlük hedef
          _detailRow(
            context,
            C.activity.detailDailyTarget,
            '${details.targetCondition.displayName} ${details.dailyTarget}',
          ),
          // Toplam borç
          _detailRow(
            context,
            C.activity.detailTotalDebt,
            '${activity.totalDone}/${details.totalDebt}',
          ),
          _progressBarRow(context, activity.totalDone / details.totalDebt),
        ];
      case ActivityType.fasting:
        final details = activity.fastingDetails!;
        return [
          // Toplam borç
          _detailRow(
            context,
            C.activity.detailTotalDebt,
            '${activity.totalDone}/${details.totalDebt}',
          ),
          _progressBarRow(context, activity.totalDone / details.totalDebt),
        ];
      case ActivityType.quran:
        final details = activity.quranDetails!;
        final selectedContent = _getQuranContent(details);

        // Hedef birimi (Sayfa, Cüz veya Sure)
        return [
          _detailRow(
            context,
            C.activity.quranTargetType,
            details.targetType.displayName,
          ),
          // Hedef
          _detailRow(
            context,
            C.activity.detailTarget,
            '${activity.targetCondition.displayName} ${details.targetValue}',
          ),
          // Seçilen içerik (Cüz veya Sure)
          if (selectedContent != null)
            _detailRow(
              context,
              details.targetType == QuranTargetType.juz
                  ? C.activity.detailSelectedJuz
                  : C.activity.detailSelectedSurah,
              selectedContent,
            ),
          _progressBarRow(context, activity.totalDone / details.targetValue),
        ];
      case ActivityType.dhikr:
        final details = activity.dhikrDetails!;
        return [
          // Hedef
          _detailRow(
            context,
            C.activity.detailTarget,
            '${activity.targetCondition.displayName} ${details.targetCount}',
          ),
          // Arapça metin
          _detailRow(context, C.activity.dhikrArabicText, details.arabicText),
          // Türkçe metin (varsa)
          if (details.turkishText != null &&
              details.turkishText!.trim().isNotEmpty)
            _detailRow(
              context,
              C.activity.dhikrTurkishText,
              details.turkishText!,
            ),
          _progressBarRow(context, activity.totalDone / details.targetCount),
        ];
    }
  }

  /// cüz seçilmişse cüz numaralarını formatla göster
  /// sure seçilmişse sure ismini göster
  /// sayfa seçilmişse gösterme.
  String? _getQuranContent(QuranDetails details) {
    return switch (details.targetType) {
      QuranTargetType.juz =>
        details.selectedJuzNumbers.map((number) => "$number").join(', '),
      QuranTargetType.surah =>
        details.selectedSurahNumber == 0
            ? C.activity.selectQuranSurah
            : C.activity.quranSurahNames[details.selectedSurahNumber - 1],
      QuranTargetType.page => null,
    };
  }

  /// Detay satırı (label ve value)
  Widget _detailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: TextStyle(color: context.onSurface.withValues(alpha: 0.6)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  /// İlerleme çubuğu satırı
  Widget _progressBarRow(BuildContext context, double progress) {
    final percentage = (progress.clamp(0.0, 1.0) * 100).toStringAsFixed(2);
    final safeProgress = progress.clamp(0.0, 1.0);
    final isOverachieved = progress > 1.0;
    final dynamicColor =
        Color.lerp(Colors.red, Colors.green, safeProgress) ?? context.primary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Toplam ilerleme:",
            style: TextStyle(color: context.onSurface.withValues(alpha: 0.6)),
          ),

          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '%$percentage',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isOverachieved ? Colors.green : context.onSurface,
              ),
            ),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              height: 6,
              width: double.infinity,
              child: LinearProgressIndicator(
                value: safeProgress,
                backgroundColor: context.secondaryContainer.withValues(
                  alpha: 0.4,
                ),
                valueColor: AlwaysStoppedAnimation<Color>(dynamicColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
