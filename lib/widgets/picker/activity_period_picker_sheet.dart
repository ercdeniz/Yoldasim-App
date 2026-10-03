import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/widgets/utils/drag_hendle.dart';

typedef C = AppConstants;

class ActivityPeriodPickerSheet extends StatelessWidget {
  final ActivityPeriod initialPeriod;
  final ValueChanged<ActivityPeriod> onPeriodSelected;

  const ActivityPeriodPickerSheet({
    super.key,
    required this.initialPeriod,
    required this.onPeriodSelected,
  });

  static void show({
    required ActivityPeriod initialPeriod,
    required ValueChanged<ActivityPeriod> onPeriodSelected,
  }) {
    Get.bottomSheet(
      ActivityPeriodPickerSheet(
        initialPeriod: initialPeriod,
        onPeriodSelected: onPeriodSelected,
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedPeriod = initialPeriod.obs;

    return Material(
      color: context.scaffoldBackgroundColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const DragHandle(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  C.activity.periodTitle,
                  style: context.text.titleLarge,
                ),
              ),
              ...[
                ActivityPeriod.daily,
                ActivityPeriod.weekly,
                ActivityPeriod.monthly,
                ActivityPeriod.allTime,
              ].map(
                (period) => Obx(
                  () => ListTile(
                    title: Text(period.displayName),
                    trailing: selectedPeriod.value == period
                        ? Icon(Icons.check_circle, color: context.primary)
                        : null,
                    onTap: () {
                      selectedPeriod.value = period;
                      onPeriodSelected(period);
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
