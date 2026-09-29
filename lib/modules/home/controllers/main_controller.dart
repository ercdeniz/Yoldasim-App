import 'package:get/get.dart';

class HomeController extends GetxController {

  // seçili sayfa indexi
  var currentIndex = 0.obs;

  // tıklanan sayfaya geçiş yap
  void changePage(int index) {
    currentIndex.value = index;
  }
}
