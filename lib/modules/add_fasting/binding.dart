import 'package:get/get.dart';
import 'controller.dart';

class AddFastingBinding extends Bindings {
	@override
	void dependencies() {
		Get.lazyPut<AddFastingController>(() => AddFastingController());
	}
}
