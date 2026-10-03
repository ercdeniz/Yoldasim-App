import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/date_extensions.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/modules/add_fasting/controller.dart';
import 'package:yoldasim_app/widgets/inputs/number_input_field.dart';
import 'package:yoldasim_app/widgets/dialogs/date_picker_dialog.dart';
import 'package:yoldasim_app/widgets/tiles/icon_list_item.dart';

typedef C = AppConstants;

class FastingFormSection extends GetView<AddFastingController> {
  const FastingFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.secondaryContainer,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          NumberInputField(
            label: C.activity.fastingTotalDebt,
            hint: 'Örn: 30',
            requirement: FieldRequirement.mandatory,
            onChanged: (value) => controller.totalDebt.value = value,
            isError: controller.isTotalDebtEmpty,
          ),
          AddPageListItem(
            title: C.activity.startDate,
            subtitle: Obx(
              () => Text(controller.selectedStartDate.value.formattedDate),
            ),
            icon: Icons.calendar_today,
            requirement: FieldRequirement.optional,
            iconBGColor: Colors.green,
            onTap: () => AppDatePickerDialog.show(
              initialDate: controller.selectedStartDate.value,
              onDateSelected: (date) =>
                  controller.selectedStartDate.value = date,
            ),
          ),
        ],
      ),
    );
  }
}