import 'package:get/get.dart';
import 'controller.dart';

class AddSalahBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AddSalahController>(() => AddSalahController());
  }
}