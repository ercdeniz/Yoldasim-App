import 'package:get/get.dart';

import 'controller.dart';

class AddDhikrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddDhikrController>(() => AddDhikrController());
  }
}
