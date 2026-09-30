import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';

class AppDatePickerDialog extends StatelessWidget {
  final DateTime initialDate;
  final ValueChanged<DateTime> onDateSelected;

  const AppDatePickerDialog({
    super.key,
    required this.initialDate,
    required this.onDateSelected,
  });

  static void show({
    required DateTime initialDate,
    required ValueChanged<DateTime> onDateSelected,
  }) {
    Get.dialog(
      AppDatePickerDialog(
        initialDate: initialDate,
        onDateSelected: onDateSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color textColor = context.textTheme.bodyLarge?.color ?? Colors.black;
    final Color passiveTextColor = Colors.grey.shade400;
    final Rx<DateTime> localSelectedDate = initialDate.obs;

    return Obx(
      () => AlertDialog(
        backgroundColor: context.scaffoldBackgroundColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        contentPadding: const EdgeInsets.all(12.0),
        content: SizedBox(
          width: context.widthScreen * 0.85,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TableCalendar(
                locale: 'tr_TR',
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2050, 12, 31),
                focusedDay: localSelectedDate.value,
                currentDay: DateTime.now(),
                startingDayOfWeek: StartingDayOfWeek.monday,
                selectedDayPredicate: (day) =>
                    isSameDay(localSelectedDate.value, day),
                onDaySelected: (selectedDay, focusedDay) {
                  localSelectedDate.value = selectedDay;
                  onDateSelected(selectedDay);
                  Navigator.of(context, rootNavigator: true).maybePop();
                },
                headerStyle: _buildHeaderStyle(context, textColor),
                daysOfWeekStyle: _buildDaysOfWeekStyle(),
                calendarStyle: _buildCalendarStyle(
                  context,
                  textColor,
                  passiveTextColor,
                  localSelectedDate.value,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  HeaderStyle _buildHeaderStyle(BuildContext context, Color textColor) {
    return HeaderStyle(
      formatButtonVisible: false,
      titleCentered: true,
      leftChevronIcon: Icon(Icons.chevron_left, color: textColor),
      rightChevronIcon: Icon(Icons.chevron_right, color: textColor),
      titleTextStyle: TextStyle(
        fontSize: context.text.titleLarge!.fontSize,
        fontWeight: context.text.titleLarge!.fontWeight,
        color: textColor,
      ),
    );
  }

  DaysOfWeekStyle _buildDaysOfWeekStyle() {
    return const DaysOfWeekStyle(
      weekdayStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
      weekendStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
    );
  }

  CalendarStyle _buildCalendarStyle(
    BuildContext context,
    Color textColor,
    Color passiveTextColor,
    DateTime selectedDate,
  ) {
    return CalendarStyle(
      defaultTextStyle: TextStyle(color: textColor),
      weekendTextStyle: TextStyle(color: textColor),
      outsideTextStyle: TextStyle(color: passiveTextColor),
      todayDecoration: const BoxDecoration(color: Colors.transparent),
      todayTextStyle: TextStyle(
        color: context.primary,
        fontWeight: FontWeight.bold,
      ),
      selectedDecoration: BoxDecoration(
        color: context.primary,
        shape: BoxShape.circle,
      ),
      selectedTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}
