import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/date_extensions.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/modules/add_salah/controller.dart';
import 'package:yoldasim_app/modules/add_salah/widgets/sheets/time_picker_sheet.dart';
import 'package:yoldasim_app/widgets/picker/date_picker_dialog.dart';
import 'package:yoldasim_app/widgets/tiles/icon_list_item.dart';

typedef C = AppConstants;

class SalahDateTimeSection extends GetView<AddSalahController> {
  const SalahDateTimeSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.secondaryContainer,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // VAKİT SEÇİMİ
          AddPageListItem(
            title: C.activity.salahTime,
            subtitle: Obx(() => Text(controller.selectedTimeText.value)),
            icon: Icons.access_time_filled,
            requirement: FieldRequirement.mandatory,
            iconBGColor: Colors.blueAccent,
            onTap: () => SalahTimePickerSheet.show(),
          ),

          // BAŞLANGIÇ TARİHİ SEÇİMİ
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
