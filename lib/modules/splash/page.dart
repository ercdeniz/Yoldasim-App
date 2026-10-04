import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:yoldasim_app/core/constants/app_assets.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/data/services/isar_service.dart';
import 'package:yoldasim_app/modules/home/controllers/calendar_controller.dart';
import 'package:yoldasim_app/modules/home/controllers/home_controller.dart';
import 'package:yoldasim_app/modules/home/controllers/listing_controller.dart';
import 'package:yoldasim_app/routes/app_routes.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State createState() => _SplashPageState();
}

class _SplashPageState extends State with TickerProviderStateMixin {
  late final AnimationController _lottieController;
  bool _isInitStarted = false;
  bool _hasError = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();

    _lottieController = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  Future _initializeApp({LottieComposition? composition}) async {
    if (_isInitStarted) return;
    _isInitStarted = true;
    setState(() {
      _hasError = false;
      _errorMessage = '';
    });

    try {
      if (composition != null) {
        _lottieController.duration = composition.duration;
      }
      bool isTasksCompleted = false;

      final backgroundTasks = () async {
        try {
          final isarService = IsarService();
          await isarService.init();
          Get.put(isarService, permanent: true);

          Get.put(HomeController(), permanent: true);
          Get.put(ListingController(), permanent: true);
          final calendarController = Get.put(
            CalendarController(),
            permanent: true,
          );

          await calendarController.getDailyRecordsForDate();
        } finally {
          isTasksCompleted = true;
        }
      }();

      do {
        _lottieController.reset();
        await _lottieController.forward();
      } while (!isTasksCompleted);

      await backgroundTasks;

      Get.offAllNamed(AppRoutes.HOME);
    } catch (e) {
      String friendlyMessage = C.errors.splashLoadErrorGeneral;
      final errorString = e.toString().toLowerCase();
      final errDBKeywords = ["isar", "database", "supabase", "db"];
      final errNetworkKeywords = ["timeout", "network", "connection", "socket"];

      if (errDBKeywords.any((keyword) => errorString.contains(keyword))) {
        friendlyMessage = C.errors.splashLoadErrorDatabase;
      } else if (errNetworkKeywords.any(
        (keyword) => errorString.contains(keyword),
      )) {
        friendlyMessage = C.errors.splashLoadErrorNetwork;
      } else if (errorString.contains("permission")) {
        friendlyMessage = C.errors.splashLoadErrorPermission;
      }

      setState(() {
        _hasError = true;
        _errorMessage = friendlyMessage;
        _isInitStarted = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      body: Center(
        child: _hasError
            ? _buildErrorView(context)
            : _buildAnimationView(context),
      ),
    );
  }

  Widget _buildErrorView(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.warning_amber_rounded, size: 72, color: context.error),
          const SizedBox(height: 16),
          Text(
            C.errors.splashLoadErrorTitle,
            style: TextStyle(
              fontSize: context.text.titleLarge?.fontSize,
              fontWeight: FontWeight.bold,
              color: context.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            C.errors.splashLoadErrorDesc,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.text.bodyMedium?.fontSize,
              color: context.onSurface.withValues(alpha: 0.7),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: () => _initializeApp(),
            icon: const Icon(Icons.refresh),
            label: Text(C.errors.splashLoadErrorRetry),
            style: FilledButton.styleFrom(
              backgroundColor: context.primary,
              shape: StadiumBorder(),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            _errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  // Normal durumda gösterilecek Animasyon UI
  Widget _buildAnimationView(BuildContext context) {
    return RepaintBoundary(
      child: ColorFiltered(
        colorFilter: ColorFilter.mode(context.onSurface, BlendMode.srcIn),
        child: Lottie.asset(
          AppAssets.lottieBismillah,
          width: context.width,
          fit: BoxFit.contain,
          frameRate: FrameRate.max,
          controller: _lottieController,
          onLoaded: (composition) {
            _initializeApp(composition: composition);
          },
        ),
      ),
    );
  }
}
