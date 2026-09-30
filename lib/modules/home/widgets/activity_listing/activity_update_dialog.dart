import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/snackbar_extentions.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/data/models/activity_model.dart';
import 'package:yoldasim_app/modules/home/controllers/listing_controller.dart';

typedef C = AppConstants;

class ActivityUpdateDialog extends StatelessWidget {
  final ActivityModel activity;
  final int currentDailyDone;
  final int dailyTarget;
  final TargetCondition condition;

  const ActivityUpdateDialog({
    super.key,
    required this.activity,
    required this.currentDailyDone,
    required this.dailyTarget,
    required this.condition,
  });

  ListingController get listingController => Get.find<ListingController>();

  @override
  Widget build(BuildContext context) {
    final counter = currentDailyDone.obs;

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      title: Center(
        child: Text(
          C.activity.updateTarget,
          style: TextStyle(
            fontSize: context.text.headlineSmall?.fontSize,
            color: colorScheme.onSurface,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _CounterBox(counter: counter, colorScheme: colorScheme),
          const SizedBox(height: 16),
          Text(
            C.activity.targetDisplay(condition.displayName, dailyTarget),
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: context.text.labelMedium?.fontSize,
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context, rootNavigator: true).maybePop(),
          child: Text(
            C.common.cancel,
            style: TextStyle(
              color: colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: context.text.bodyLarge?.fontSize,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            var hasError = await listingController.saveActivityProgress(
              activity,
              counter.value,
              currentDailyDone,
            );
            if (hasError != null) {
              '${C.activity.updateErrorBase}$hasError'.errorSnackbar();
            }
            if (context.mounted) {
              Navigator.of(context, rootNavigator: true).maybePop();
            }
          },
          child: Text(
            C.common.update,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: context.text.titleMedium?.fontSize,
            )
          ),
        ),
      ],
    );
  }
}

class _CounterBox extends StatelessWidget {
  final RxInt counter;
  final ColorScheme colorScheme;

  const _CounterBox({required this.counter, required this.colorScheme});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // EKSİ BUTONU
          Obx(() {
            final isMinusDisabled = counter.value <= 0;
            return Container(
              decoration: BoxDecoration(
                color: isMinusDisabled
                    ? colorScheme.primary.withValues(alpha: 0.35)
                    : colorScheme.primary.withValues(alpha: 0.75),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                onPressed: isMinusDisabled ? null : () => counter.value--,
                icon: Icon(Icons.remove, color: colorScheme.surface),
              ),
            );
          }),

          // ORTADAKİ RAKAM
          Obx(
            () => Text(
              '${counter.value}',
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                fontSize: 56,
                color: colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // ARTI BUTONU
          Container(
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.75),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              onPressed: () => counter.value++,
              icon: Icon(Icons.add, color: colorScheme.surface),
            ),
          ),
        ],
      ),
    );
  }
}
