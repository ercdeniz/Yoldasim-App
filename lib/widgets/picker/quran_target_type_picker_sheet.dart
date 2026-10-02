import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';

typedef C = AppConstants;

class QuranTargetTypePickerSheet extends StatelessWidget {
  final QuranTargetType initialType;
  final ValueChanged<QuranTargetType> onTypeSelected;

  const QuranTargetTypePickerSheet({
    super.key,
    required this.initialType,
    required this.onTypeSelected,
  });

  static void show({
    required QuranTargetType initialType,
    required ValueChanged<QuranTargetType> onTypeSelected,
  }) {
    Get.bottomSheet(
      QuranTargetTypePickerSheet(
        initialType: initialType,
        onTypeSelected: onTypeSelected,
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedType = initialType.obs;

    return Material(
      color: context.scaffoldBackgroundColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  C.activity.quranTargetType,
                  style: context.text.titleLarge,
                ),
              ),
              ...QuranTargetType.values.map(
                (type) => Obx(
                  () => ListTile(
                    title: Text(type.displayName),
                    trailing: selectedType.value == type
                        ? Icon(Icons.check_circle, color: context.primary)
                        : null,
                    onTap: () {
                      selectedType.value = type;
                      onTypeSelected(type);
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