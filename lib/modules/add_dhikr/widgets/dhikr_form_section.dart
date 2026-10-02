import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/date_extensions.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/modules/add_dhikr/controller.dart';
import 'package:yoldasim_app/widgets/inputs/number_input_field.dart';
import 'package:yoldasim_app/widgets/picker/activity_period_picker_sheet.dart';
import 'package:yoldasim_app/widgets/picker/activity_schedule_picker_sheet.dart';
import 'package:yoldasim_app/widgets/picker/date_picker_dialog.dart';
import 'package:yoldasim_app/widgets/picker/target_condition_picker_button.dart';
import 'package:yoldasim_app/widgets/carts/field_requirement_badge.dart';
import 'package:yoldasim_app/widgets/tiles/icon_list_item.dart';

typedef C = AppConstants;

/// Zikir ekleme sayfasındaki form alanlarını içeren widget
class DhikrFormSection extends GetView<AddDhikrController> {
  const DhikrFormSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.colors.secondaryContainer,
      borderRadius: BorderRadius.circular(16),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          // Zikir hedef sayısı alanı
          NumberInputField(
            label: C.activity.dhikrTargetCount,
            hint: C.activity.dhikrTargetHint,
            requirement: FieldRequirement.mandatory,
            onChanged: (value) => controller.targetCount.value = value,
            isError: controller.isTargetEmpty,
            trailing: TargetConditionPickerButton(
              condition: controller.selectedTargetCondition,
            ),
          ),
          // Arapça metin alanı
          _TextField(
            label: C.activity.dhikrArabicText,
            hint: C.activity.dhikrArabicHint,
            requirement: FieldRequirement.mandatory,
            isRtl: true,
            isError: controller.isArabicTextEmpty,
            onChanged: (value) => controller.arabicText.value = value,
          ),
          // Türkçe metin alanı
          _TextField(
            label: C.activity.dhikrTurkishText,
            hint: C.activity.dhikrTurkishHint,
            requirement: FieldRequirement.optional,
            isRtl: false,
            onChanged: (value) => controller.turkishText.value = value,
          ),
          // Zikir periyodu alanı
          AddPageListItem(
            title: C.activity.quranPeriod,
            subtitle: Obx(
              () => Text(controller.selectedPeriod.value.displayName),
            ),
            icon: Icons.repeat,
            requirement: FieldRequirement.mandatory,
            iconBGColor: Colors.deepPurple,
            onTap: () => ActivityPeriodPickerSheet.show(
              initialPeriod: controller.selectedPeriod.value,
              onPeriodSelected: (period) =>
                  controller.selectedPeriod.value = period,
            ),
          ),
          // Gün seçimi alanı, sadece periyot günlük değilse gösterilir
          Obx(
                () => controller.selectedPeriod.value == ActivityPeriod.daily ||
                  controller.selectedPeriod.value == ActivityPeriod.allTime
                ? const SizedBox.shrink()
                : AddPageListItem(
                    title: C.activity.scheduledDays,
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
          // Başlangıç tarihi alanı
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

class _TextField extends StatelessWidget {
  final String label;
  final String hint;
  final FieldRequirement requirement;
  final bool isRtl;
  final RxBool? isError;
  final ValueChanged<String> onChanged;

  const _TextField({
    required this.label,
    required this.hint,
    required this.requirement,
    required this.isRtl,
    required this.onChanged,
    this.isError,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 4, right: 4, bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: context.text.bodyMedium?.fontSize,
                      fontWeight: context.text.bodyMedium?.fontWeight,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                FieldRequirementBadge(requirement: requirement),
              ],
            ),
          ),
          isError == null
              ? _buildField(context)
              : Obx(() => _buildField(context)),
        ],
      ),
    );
  }

  TextFormField _buildField(BuildContext context) {
    return TextFormField(
      minLines: 1,
      maxLines: 3,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      textAlign: isRtl ? TextAlign.right : TextAlign.left,
      autocorrect: false,
      enableSuggestions: false,
      smartDashesType: SmartDashesType.disabled,
      smartQuotesType: SmartQuotesType.disabled,
      style: TextStyle(fontSize: context.text.bodyMedium?.fontSize),
      onChanged: onChanged,
      decoration: InputDecoration(
        hintText: hint,
        hintTextDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
        filled: true,
        fillColor: context.scaffoldBackgroundColor.withValues(alpha: 0.5),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isError?.value == true
                ? Colors.redAccent
                : Colors.transparent,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: isError?.value == true ? Colors.redAccent : context.primary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
      ),
    );
  }
}
