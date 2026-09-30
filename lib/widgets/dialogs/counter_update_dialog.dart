import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/snackbar_extentions.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';

typedef CounterUpdateCallback = Future<String?> Function(int value);

typedef C = AppConstants;

class CounterUpdateDialog extends StatelessWidget {
  final int currentValue;
  final int target;
  final TargetCondition condition;
  final CounterUpdateCallback onSave;

  const CounterUpdateDialog({
    super.key,
    required this.currentValue,
    required this.target,
    required this.condition,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    final counter = currentValue.obs;
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
            C.activity.targetDisplay(condition.displayName, target),
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
          onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
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
            final error = await onSave(counter.value);
            if (error != null) {
              '${C.activity.updateErrorBase}$error'.errorSnackbar();
            }
            if (context.mounted) {
              Navigator.of(context, rootNavigator: true).pop();
            }
          },
          child: Text(
            C.common.update,
            style: TextStyle(
              color: colorScheme.primary,
              fontSize: context.text.titleMedium?.fontSize,
            ),
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