import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:yoldasim_app/core/extensions/date_extensions.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/modules/home/controllers/calendar_controller.dart';

/// Tarih şeridi widgeti.
/// Bu widget, yatay bir liste olarak günleri gösterir.
class HorizontalDateStrip extends StatelessWidget {
  const HorizontalDateStrip({super.key});

  CalendarController get calendarController => Get.find<CalendarController>();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: CalendarController.dateStripHeight,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: calendarController.itemScrollController,
          padding: const EdgeInsets.symmetric(
            horizontal: CalendarController.dateStripLeftPadding,
          ),
          itemCount: calendarController.dateList.length,
          itemBuilder: (context, index) {
            final date = calendarController.dateList[index];
            final isSelected = calendarController.selectedDate.value.onlyDate == date.onlyDate;

            return GestureDetector(
              onTap: () {
                calendarController.selectDateFromStrip(date);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: CalendarController.dateItemWidth,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.primary
                      : context.cardColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      DateFormat('E', 'tr_TR').format(date).toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        color: isSelected
                            ? Colors.white
                            : context.text.bodyMedium?.color,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${date.day}',
                      style: TextStyle(
                        fontSize: 16,
                        color: isSelected
                            ? Colors.white
                            : context.text.bodyLarge?.color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
