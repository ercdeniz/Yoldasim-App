import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/modules/add_salah/controller.dart';
import 'package:yoldasim_app/widgets/carts/mandatory_switch_card.dart';
import 'package:yoldasim_app/widgets/inputs/number_input_field.dart';
import 'package:yoldasim_app/widgets/tiles/icon_list_item.dart';

typedef C = AppConstants;

class AddSalahPage extends GetView<AddSalahController> {
  const AddSalahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          C.activity.salahTitle,
          style: context.theme.textTheme.titleLarge,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.check, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: context.theme.primaryColor.withValues(
                  alpha: 0.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {
                controller.saveActivity();
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // VAKİT SEÇİMİ
                Material(
                  color: context.theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      IconListItem(
                        title: C.activity.salahTime,
                        subtitle: Obx(
                          () => Text(controller.selectedTimeText.value),
                        ),
                        icon: Icons.access_time_filled,
                        requirement: FieldRequirement.mandatory,
                        iconBGColor: Colors.blueAccent,
                        onTap: () {
                          controller.showTimePickerSheet(context);
                        },
                      ),
                      // Başlangıç Tarihi Seçimi
                      IconListItem(
                        title: C.activity.pickStartDate,
                        subtitle: Obx(
                          () => Text(
                            DateFormat(
                              'dd MMMM yyyy',
                              'tr_TR',
                            ).format(controller.selectedStartDate.value),
                          ),
                        ),
                        icon: Icons.calendar_today,
                        requirement: FieldRequirement.optional,
                        iconBGColor: Colors.greenAccent,
                        onTap: () {
                          controller.pickStartDate(context);
                        },
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // BORÇ VE HEDEF GİRİŞİ
                Material(
                  color: context.theme.colorScheme.secondaryContainer,
                  borderRadius: BorderRadius.circular(16),
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      NumberInputField(
                        label: C.activity.salahTotalDebt,
                        hint: 'Örn: 300',
                        requirement: FieldRequirement.mandatory,
                        onChanged: (value) =>
                            controller.totalDebt.value = value,
                        isError: controller.isTotalDebtEmpty,
                      ),

                      NumberInputField(
                        label: C.activity.dailyTarget,
                        hint: 'Örn: 5',
                        requirement: FieldRequirement.mandatory,
                        onChanged: (value) =>
                            controller.dailyTarget.value = value,
                        isError: controller.isDailyTargetEmpty,
                        trailing: conditionPicker(context),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ZORUNLULUK AYARI
                MandatorySwitchCard(isMandatory: controller.isDailyMandatory),
              ],
            ),
          ),
        ),
      ),
    );
  }

  InkWell conditionPicker(BuildContext context) {
    return InkWell(
      onTap: () => controller.showConditionPickerSheet(context),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                controller.targetConditionNames[controller
                    .selectedTargetCondition
                    .value]!,
                style: TextStyle(color: context.theme.primaryColor),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: context.theme.primaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
