import 'package:get/get.dart';
import 'controller.dart';

class AddQuranBinding extends Bindings {
	@override
	void dependencies() {
		Get.lazyPut<AddQuranController>(() => AddQuranController());
	}
}
