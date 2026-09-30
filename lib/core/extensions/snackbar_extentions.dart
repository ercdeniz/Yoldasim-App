import 'package:flutter/material.dart';
import 'package:get/get.dart';

extension StringSnackbarExtension on String {
  void errorSnackbar({String title = 'Hata'}) {
    Get.snackbar(
      title,
      this,
      backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
      duration: const Duration(seconds: 2),
    );
  }

  void successSnackbar({String title = 'Başarılı'}) {
    Get.snackbar(
      title,
      this,
      backgroundColor: Colors.green.withValues(alpha: 0.1),
      duration: const Duration(seconds: 2),
    );
  }
}
