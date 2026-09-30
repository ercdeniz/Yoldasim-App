import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/modules/add_salah/controller.dart';

class SalahTimePickerSheet extends StatelessWidget {
  SalahTimePickerSheet({super.key});

  final controller = Get.find<AddSalahController>();

  static void show() {
    Get.bottomSheet(SalahTimePickerSheet(), isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.scaffoldBackgroundColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDragHandle(),
              const SizedBox(height: 16),
              Text(C.activity.selectTimeTitle, style: context.text.titleLarge),
              const SizedBox(height: 16),
              _buildTimeList(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  Widget _buildTimeList(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: SalahTime.values
          .map((time) => _buildTimeTile(context, time))
          .toList(),
    );
  }

  Widget _buildTimeTile(BuildContext context, SalahTime time) {
    return Obx(() {
      final bool isSelected = controller.selectedTime.value == time;

      return ListTile(
        title: Text(
          time.displayName,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            color: isSelected ? context.primary : null,
          ),
        ),
        trailing: isSelected
            ? Icon(Icons.check_circle, color: context.primary)
            : null,
        onTap: () {
          controller.selectedTime.value = time;
          controller.selectedTimeText.value = time.displayName;
          Navigator.of(context, rootNavigator: true).maybePop();
        },
      );
    });
  }
}
