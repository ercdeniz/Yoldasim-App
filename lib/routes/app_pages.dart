import 'package:get/get.dart';
import 'package:yoldasim_app/modules/add_fasting/binding.dart';
import 'package:yoldasim_app/modules/add_fasting/page.dart';
import 'package:yoldasim_app/modules/add_quran/binding.dart';
import 'package:yoldasim_app/modules/add_quran/page.dart';
import 'package:yoldasim_app/modules/add_dhikr/binding.dart';
import 'package:yoldasim_app/modules/add_dhikr/page.dart';
import 'package:yoldasim_app/modules/add_salah/binding.dart';
import 'package:yoldasim_app/modules/add_salah/page.dart';
import 'package:yoldasim_app/modules/splash/binding.dart';
import 'package:yoldasim_app/modules/splash/page.dart';

import 'app_routes.dart';
import '../modules/home/binding.dart';
import '../modules/home/page.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.SPLASH,
      page: () => const SplashPage(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    /*
    GetPage(
      name: AppRoutes.STATS,
      page: () => const StatsView(),
      binding: StatsBinding(),
    ),
    */
    GetPage(
      name: AppRoutes.SALAH,
      page: () => const AddSalahPage(),
      binding: AddSalahBinding(),
    ),

    GetPage(
      name: AppRoutes.FASTING,
      page: () => const AddFastingPage(),
      binding: AddFastingBinding(),
    ),

    GetPage(
      name: AppRoutes.DHIKR,
      page: () => const AddDhikrPage(),
      binding: AddDhikrBinding(),
    ),
    GetPage(
      name: AppRoutes.QURAN,
      page: () => const AddQuranPage(),
      binding: AddQuranBinding(),
    ),
  ];
}
