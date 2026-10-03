import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/date_extensions.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/modules/add_quran/controller.dart';
import 'package:yoldasim_app/widgets/inputs/number_input_field.dart';
import 'package:yoldasim_app/widgets/picker/activity_period_picker_sheet.dart';
import 'package:yoldasim_app/widgets/picker/activity_schedule_picker_sheet.dart';
import 'package:yoldasim_app/modules/add_quran/widgets/quran_target_type_picker_sheet.dart';
import 'package:yoldasim_app/modules/add_quran/widgets/quran_juz_picker_sheet.dart';
import 'package:yoldasim_app/modules/add_quran/widgets/quran_surah_picker/quran_surah_picker_sheet.dart';
import 'package:yoldasim_app/widgets/picker/target_condition_picker_button.dart';
import 'package:yoldasim_app/widgets/tiles/icon_list_item.dart';
import 'package:yoldasim_app/widgets/dialogs/date_picker_dialog.dart';

typedef C = AppConstants;

class QuranFormSection extends GetView<AddQuranController> {
  const QuranFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.secondaryContainer,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          AddPageListItem(
            title: C.activity.quranTargetType,
            subtitle: Obx(() => Text(controller.targetTypeName)),
            icon: Icons.menu_book,
            requirement: FieldRequirement.mandatory,
            iconBGColor: ActivityType.quran.color,
            onTap: () => QuranTargetTypePickerSheet.show(
              initialType: controller.selectedTargetType.value,
              onTypeSelected: controller.selectTargetType,
            ),
          ),
          Obx(() {
            if (controller.selectedTargetType.value == QuranTargetType.page) {
              return const SizedBox.shrink();
            }

            final isJuz =
                controller.selectedTargetType.value == QuranTargetType.juz;
            return AddPageListItem(
              title: isJuz ? C.activity.quranJuz : C.activity.quranSurah,
              subtitle: Text(controller.selectedContentName),
              icon: isJuz ? Icons.looks_one_outlined : Icons.menu_book_outlined,
              requirement: FieldRequirement.mandatory,
              iconBGColor: ActivityType.quran.color,
              onTap: () {
                if (isJuz) {
                  QuranJuzPickerSheet.show(
                    initialJuzNumbers: controller.selectedJuzNumbers.toList(),
                    onJuzSelected: (juzNumbers) =>
                        controller.selectedJuzNumbers.assignAll(juzNumbers),
                  );
                } else {
                  QuranSurahPickerSheet.show(
                    initialSurah: controller.selectedSurahNumber.value,
                    onSurahSelected: (surah) =>
                        controller.selectedSurahNumber.value = surah,
                  );
                }
              },
            );
          }),
          NumberInputField(
            label: C.activity.quranTargetValue,
            hint: C.activity.quranTargetHint,
            requirement: FieldRequirement.mandatory,
            onChanged: (value) => controller.targetValue.value = value,
            isError: controller.isTargetEmpty,
            trailing: TargetConditionPickerButton(
              condition: controller.selectedTargetCondition,
            ),
          ),
          AddPageListItem(
            title: C.activity.quranPeriod,
            subtitle: Obx(() => Text(controller.selectedPeriod.value.displayName)),
            icon: Icons.repeat,
            requirement: FieldRequirement.mandatory,
            iconBGColor: Colors.deepPurple,
            onTap: () => ActivityPeriodPickerSheet.show(
              initialPeriod: controller.selectedPeriod.value,
              onPeriodSelected: (period) =>
                  controller.selectedPeriod.value = period,
            ),
          ),
          Obx(
                () => controller.selectedPeriod.value == ActivityPeriod.daily ||
                  controller.selectedPeriod.value == ActivityPeriod.allTime
                ? const SizedBox.shrink()
                : AddPageListItem(
                    title: C.activity.selectDays,
                    subtitle: Text(controller.scheduleSummary),
                    icon: Icons.event_available,
                    requirement: FieldRequirement.mandatory,
                    iconBGColor: Colors.teal,
                    onTap: () => ActivitySchedulePickerSheet.show(
                      period: controller.selectedPeriod.value,
                      initialWeeklyDays: controller.weeklyDays.toList(),
                      initialMonthlyDays: controller.monthlyDays.toList(),
                      onWeeklyDaysSelected: (days) =>
                          controller.weeklyDays.assignAll(days),
                      onMonthlyDaysSelected: (days) =>
                          controller.monthlyDays.assignAll(days),
                    ),
                  ),
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