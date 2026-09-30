import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';

typedef C = AppConstants;

class MandatorySwitchCard extends StatelessWidget {
  final RxBool isMandatory;

  const MandatorySwitchCard({super.key, required this.isMandatory});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.secondaryContainer,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Obx(
        () => SwitchListTile(
          title: Text(
            C.activity.mandatory,
            style: TextStyle(
              fontSize: context.text.titleMedium?.fontSize,
            ),
          ),
          subtitle: Text(
            C.activity.mandatoryDesc,
            style: TextStyle(
              fontSize: context.text.labelSmall?.fontSize,
            ),
          ),
          value: isMandatory.value,
          onChanged: (value) {
            isMandatory.value = value;
          },
          activeThumbColor: context.primary,
        ),
      ),
    );
  }
}
