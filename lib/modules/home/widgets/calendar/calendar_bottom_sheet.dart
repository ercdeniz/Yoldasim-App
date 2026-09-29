// lib/modules/home/widgets/calendar_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yoldasim_app/modules/home/controllers/calendar_controller.dart';

class CalendarBottomSheet extends StatelessWidget {
  const CalendarBottomSheet({super.key});

  // Controller'a erişim (StatelessWidget olduğu için rahatça Get.find yapıyoruz)
  CalendarController get calendarController => Get.find<CalendarController>();

  /// Bu bottom sheet'i ekranda açan statik tetikleyici metot
  static void show() {
    Get.bottomSheet(const CalendarBottomSheet(), isScrollControlled: true);
  }

  @override
  Widget build(BuildContext context) {
    final textColor = context.theme.textTheme.bodyLarge?.color;
    final passiveTextColor = context.theme.textTheme.bodyMedium?.color
        ?.withValues(alpha: 0.5);

    return Container(
      decoration: BoxDecoration(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Obx(
            () => TableCalendar(
              locale: 'tr_TR',
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2050, 12, 31),
              focusedDay: calendarController.selectedDate.value,
              currentDay: DateTime.now(),
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: (day) =>
                  isSameDay(calendarController.selectedDate.value, day),
              onDaySelected: (selectedDay, focusedDay) {
                calendarController.selectDateFromCalendar(selectedDay);
                Get.back();
              },
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                leftChevronIcon: Icon(Icons.chevron_left, color: textColor),
                rightChevronIcon: Icon(Icons.chevron_right, color: textColor),
                titleTextStyle: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
              daysOfWeekStyle: const DaysOfWeekStyle(
                weekdayStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                weekendStyle: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
              calendarStyle: CalendarStyle(
                defaultTextStyle: TextStyle(color: textColor),
                weekendTextStyle: TextStyle(color: textColor),
                outsideTextStyle: TextStyle(color: passiveTextColor),
                todayDecoration: const BoxDecoration(color: Colors.transparent),
                todayTextStyle: TextStyle(
                  color: context.theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ),
                selectedDecoration: BoxDecoration(
                  color: context.theme.primaryColor,
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // KAPAT VE BUGÜN BUTONLARI
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: () => Get.back(),
                  child: Text(
                    'KAPAT',
                    style: TextStyle(color: textColor, fontSize: 16),
                  ),
                ),
              ),
              Container(
                width: 1,
                height: 30,
                color: Colors.grey.withValues(alpha: 0.3),
              ),
              Expanded(
                child: TextButton(
                  onPressed: () {
                    calendarController.jumpToToday();
                    Get.back();
                  },
                  child: Text(
                    'BUGÜN',
                    style: TextStyle(
                      color: context.theme.primaryColor,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
