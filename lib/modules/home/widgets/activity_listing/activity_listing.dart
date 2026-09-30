import 'package:flutter/material.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/state_manager.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/extensions/date_extensions.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/modules/home/controllers/calendar_controller.dart';
import 'package:yoldasim_app/modules/home/controllers/listing_controller.dart';
import 'package:yoldasim_app/modules/home/controllers/home_controller.dart';
import 'package:yoldasim_app/modules/home/widgets/activity_listing/activity_router.dart';

typedef C = AppConstants;

/// Aktivite listeleme widgeti.
/// Bu widget, seçilen tarihe göre aktiviteleri filtreler
/// Liste elemanlarını oluşturmak için [ActivityRouter] widget'ını kullanır.
/// Listelenecek bir aktivite yoksa kullanıcıya bilgilendirme mesajı gösterir.
class ActivityListing extends StatelessWidget {
  const ActivityListing({super.key});

  HomeController get mainController => Get.find<HomeController>();
  CalendarController get calendarController => Get.find<CalendarController>();
  ListingController get listingController => Get.find<ListingController>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Obx(() {
        final filteredActivities = listingController.activities.where((
          activity,
        ) {
          final targetDate = calendarController.selectedDate.value.onlyDate;
          final activityDate = activity.startDate.onlyDate;

          return targetDate.compareTo(activityDate) >= 0;
        }).toList();

        if (filteredActivities.isEmpty) {
          return Center(
            child: Text(
              C.home.noActivity,
              style: TextStyle(
                fontSize: context.text.titleMedium?.fontSize,
                color: context.text.bodyMedium?.color,
              ),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: filteredActivities.length,
          itemBuilder: (context, index) {
            final activity = filteredActivities[index];
            return ActivityRouter(activity: activity);
          },
        );
      }),
    );
  }
}
