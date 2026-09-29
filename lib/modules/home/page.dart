import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/modules/home/controllers/calendar_controller.dart';
import 'package:yoldasim_app/modules/home/widgets/activity_listing/activity_listing.dart';
import 'package:yoldasim_app/modules/home/widgets/calendar/calendar_bottom_sheet.dart';
import 'package:yoldasim_app/modules/home/widgets/calendar/horizontal_date_strip.dart';
import 'package:yoldasim_app/modules/home/widgets/home/add_activity_list_bottom_sheet.dart';
import 'package:yoldasim_app/modules/home/widgets/home/bottom_app_bar.dart';
import 'package:yoldasim_app/routes/app_routes.dart';

import 'controllers/main_controller.dart';

typedef C = AppConstants;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  HomeController get mainController => Get.find<HomeController>();
  CalendarController get calendarController => Get.find<CalendarController>();

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('tr_TR', null);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: GestureDetector(
          onTap: () => CalendarBottomSheet.show(),
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
                    calendarController.formatAppBarTitle(
                      calendarController.selectedDate.value,
                    ),
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
      body: Column(children: [HorizontalDateStrip(), ActivityListing()]),
      floatingActionButton: FloatingActionButton(
        onPressed: () => AddActivityBottomSheet.show(),
        backgroundColor: context.theme.primaryColor,
        elevation: 4,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, size: 32, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: HomeBottomAppBar(),
    );
  }
}
