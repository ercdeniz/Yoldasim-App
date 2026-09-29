import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/modules/home/widgets/list_operations.dart';
import 'package:yoldasim_app/routes/app_routes.dart';

import 'controllers/controller.dart';

typedef C = AppConstants;

class HomePage extends GetView<HomeController> {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('tr_TR', null);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: () => _showCalendarBottomSheet(context),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: context.theme.primaryColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Obx(
                  () => Text(
                    _formatAppBarTitle(controller.selectedDate.value),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.theme.primaryColor,
                    ),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down,
                  color: context.theme.primaryColor,
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [_buildHorizontalDateStrip(context), ListActivities()],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddActivitySheet(context),
        backgroundColor: context.theme.primaryColor,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomAppBar(context),
    );
  }

  // ekleme sayfalarına yönlendiren alt menü açılır
  void _showAddActivitySheet(BuildContext context) {
    Get.bottomSheet(
      Material(
        color: context.theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Üstteki küçük tutma/sürükleme çubuğu
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  C.activity.activityAddTitle,
                  style: context.theme.textTheme.titleLarge,
                ),
                const SizedBox(height: 16),

                // SEÇENEKLER
                // Namaz kazası
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.mosque, color: Colors.white),
                  ),
                  title: Text(C.activity.salahTitle),
                  subtitle: Text(C.activity.salahDesc),
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.SALAH);
                  },
                ),
                // Oruç kazası
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orangeAccent,
                    child: Icon(Icons.wb_sunny, color: Colors.white),
                  ),
                  title: Text(C.activity.fastingTitle),
                  subtitle: Text(C.activity.fastingDesc),
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.FASTING);
                  },
                ),
                // Kur'an hedefi
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.green,
                    child: Icon(Icons.menu_book, color: Colors.white),
                  ),
                  title: Text(C.activity.quranTitle),
                  subtitle: Text(C.activity.quranDesc),
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.QURAN);
                  },
                ),
                // Zikir / Tesbihat
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.purpleAccent,
                    child: Icon(Icons.fingerprint, color: Colors.white),
                  ),
                  title: Text(C.activity.dhikrTitle),
                  subtitle: Text(C.activity.dhikrDesc),
                  onTap: () {
                    Get.back();
                    Get.toNamed(AppRoutes.DHIKR);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- APPBAR BAŞLIK FORMATLAYICI ---
  String _formatAppBarTitle(DateTime date) {
    final now = DateTime.now();
    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return "Bugün";
    }
    // "Eyl 11, 2026" formatı
    return DateFormat('MMM d, yyyy', 'tr_TR').format(date);
  }

  // --- YATAY TARİH ŞERİDİ GÜNCELLEMESİ ---
  Widget _buildHorizontalDateStrip(BuildContext context) {
    return SizedBox(
      height: 65.0,
      child: Obx(
        () => ListView.builder(
          scrollDirection: Axis.horizontal,
          controller: controller.itemScrollController,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          itemCount: controller.dateList.length,
          itemBuilder: (context, index) {
            final date = controller.dateList[index];
            final isSelected =
                controller.selectedDate.value.year == date.year &&
                controller.selectedDate.value.month == date.month &&
                controller.selectedDate.value.day == date.day;

            return GestureDetector(
              onTap: () {
                controller.selectDateFromStrip(date);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 48,
                margin: const EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? context.theme.primaryColor
                      : context.theme.cardColor,
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
                            : context.theme.textTheme.bodyMedium?.color,
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
                            : context.theme.textTheme.bodyLarge?.color,
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

  // --- ALTTAN AÇILAN TAKVİM (BOTTOM SHEET) ---
  void _showCalendarBottomSheet(BuildContext context) {
    final textColor = context.theme.textTheme.bodyLarge?.color;
    final passiveTextColor = context.theme.textTheme.bodyMedium?.color
        ?.withValues(alpha: 0.5);

    Get.bottomSheet(
      _bottomCalendar(context, textColor, passiveTextColor),
      isScrollControlled: true,
    );
  }

  Container _bottomCalendar(
    BuildContext context,
    Color? textColor,
    Color? passiveTextColor,
  ) {
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
              focusedDay: controller.selectedDate.value,
              currentDay: DateTime.now(),
              startingDayOfWeek: StartingDayOfWeek.monday,
              selectedDayPredicate: (day) =>
                  isSameDay(controller.selectedDate.value, day),
              onDaySelected: (selectedDay, focusedDay) {
                controller.selectDateFromCalendar(selectedDay);
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
              // Gün İsimleri Stili (PZT, SAL)
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
              // Takvim İçindeki Sayıların Stili
              calendarStyle: CalendarStyle(
                defaultTextStyle: TextStyle(color: textColor),
                weekendTextStyle: TextStyle(color: textColor),
                outsideTextStyle: TextStyle(color: passiveTextColor),
                todayDecoration: const BoxDecoration(color: Colors.transparent),
                todayTextStyle: TextStyle(
                  color: context.theme.primaryColor,
                  fontWeight: FontWeight.bold,
                ), // Bugünün rengi turkuaz metin
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
              ), // Ortadaki çizgi
              Expanded(
                child: TextButton(
                  onPressed: () {
                    controller.jumpToToday();
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

  // ALT MENÜ VE BUTONLAR
  Widget _buildBottomAppBar(BuildContext context) {
    return BottomAppBar(
      color: context.theme.cardColor,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: SizedBox(
        height: 60,
        child: Obx(
          () => Row(
            children: [
              Expanded(
                child: _buildNavItem(
                  context: context,
                  icon: Icons.task_alt,
                  label: 'Görevler',
                  index: 0,
                ),
              ),
              const SizedBox(width: 48),
              Expanded(
                child: _buildNavItem(
                  context: context,
                  icon: Icons.bar_chart,
                  label: 'İstatistikler',
                  index: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- ALT MENÜ BUTONLARI ---
  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required int index,
  }) {
    final isSelected = controller.currentIndex.value == index;
    final color = isSelected
        ? context.theme.primaryColor
        : context.theme.textTheme.bodyMedium?.color;

    return InkWell(
      onTap: () => controller.changePage(index),
      highlightColor: Colors.transparent,
      splashColor: Colors.grey.withValues(alpha: 0.3),
      radius: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 26),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
