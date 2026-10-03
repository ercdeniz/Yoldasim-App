import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/widgets/utils/drag_hendle.dart';

typedef C = AppConstants;

class AppConditionPickerSheet extends StatelessWidget {
  final TargetCondition initialCondition;
  final ValueChanged<TargetCondition> onConditionSelected;

  const AppConditionPickerSheet({
    super.key,
    required this.initialCondition,
    required this.onConditionSelected,
  });

  static void show({
    required TargetCondition initialCondition,
    required ValueChanged<TargetCondition> onConditionSelected,
  }) {
    Get.bottomSheet(
      AppConditionPickerSheet(
        initialCondition: initialCondition,
        onConditionSelected: onConditionSelected,
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final Rx<TargetCondition> localCondition = initialCondition.obs;

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
                padding: const EdgeInsets.only(bottom: 16.0, top: 16.0),
                child: Text(
                  C.activity.targetConditionTitle,
                  style: context.text.titleLarge,
                ),
              ),
              _buildConditionList(context, localCondition),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConditionList(
    BuildContext context,
    Rx<TargetCondition> localCondition,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: TargetCondition.values
          .map(
            (condition) =>
                _buildConditionTile(context, condition, localCondition),
          )
          .toList(),
    );
  }

  Widget _buildConditionTile(
    BuildContext context,
    TargetCondition condition,
    Rx<TargetCondition> localCondition,
  ) {
    return Obx(() {
      final bool isSelected = localCondition.value == condition;

      return ListTile(
        title: Text(
          condition.displayName,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? context.primary : null,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: context.primary)
            : null,
        onTap: () {
          localCondition.value = condition;
          onConditionSelected(condition);
          Navigator.of(context, rootNavigator: true).pop();
        },
      );
    });
  }
}
