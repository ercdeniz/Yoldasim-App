import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:yoldasim_app/data/services/isar_service.dart';
import 'package:yoldasim_app/routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    super.onReady();
    _initializeApp();
  }

Future _initializeApp() async {
    final isarService = IsarService();
    await isarService.init();
    Get.put<IsarService>(isarService);

    await Future.delayed(const Duration(milliseconds: 1500));

    Get.offAllNamed(AppRoutes.HOME);
  }
}
