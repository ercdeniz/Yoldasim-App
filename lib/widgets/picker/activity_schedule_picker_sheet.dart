import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/widgets/picker/dual_list/dual_list_split_selector.dart';

class ActivitySchedulePickerSheet {
  static void show({
    required ActivityPeriod period,
    required List<int> initialWeeklyDays,
    required List<int> initialMonthlyDays,
    required ValueChanged<List<int>> onWeeklyDaysSelected,
    required ValueChanged<List<int>> onMonthlyDaysSelected,
  }) {
    final isWeekly = period == ActivityPeriod.weekly;

    Get.bottomSheet(
      DualListSplitSelector<int>(
        allItems: isWeekly
            ? List.generate(7, (i) => i + 1)
            : List.generate(31, (i) => i + 1),
        initialSelectedItems: isWeekly ? initialWeeklyDays : initialMonthlyDays,
        onItemsSelected: isWeekly ? onWeeklyDaysSelected : onMonthlyDaysSelected,
        headerTitle: C.activity.selectDays,
        leftPanelTitle: C.activity.days,
        rightPanelTitle: C.activity.selectedDays,
        headerIcon: isWeekly ? Icons.view_week_outlined : Icons.calendar_month_outlined,
        itemLabelBuilder: isWeekly
            ? (item) => AppConstants.daysOfWeek[item - 1]
            : null,
      ),
      isScrollControlled: true,
    );
  }
}