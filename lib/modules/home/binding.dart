import 'package:get/get.dart';
import 'package:yoldasim_app/modules/home/controllers/calendar_controller.dart';
import 'package:yoldasim_app/modules/home/controllers/listing_controller.dart';
import 'controllers/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CalendarController>(() => CalendarController());
    Get.lazyPut<ListingController>(() => ListingController());
  }
}