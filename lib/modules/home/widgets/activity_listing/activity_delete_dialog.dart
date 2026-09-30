import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/extensions/snackbar_extentions.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/data/models/activity_model.dart';
import 'package:yoldasim_app/modules/home/controllers/listing_controller.dart';

typedef C = AppConstants;

class ActivityDeleteDialog extends StatelessWidget {
  final ActivityModel activity;

  const ActivityDeleteDialog({super.key, required this.activity});

  ListingController get listingController => Get.find<ListingController>();

  static void show({required ActivityModel activity}) {
    Get.dialog(
      ActivityDeleteDialog(activity: activity),
      name: 'activity_delete_dialog',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.colors.surface,
      title: Center(
        child: Text(
          C.activity.deleteTitle,
          style: TextStyle(
            fontSize: context.text.headlineSmall?.fontSize,
            color: context.colors.onSurface,
          ),
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
            decoration: BoxDecoration(
              color: context.colors.error.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              Icons.warning_amber_rounded,
              color: context.colors.error.withValues(alpha: 0.75),
              size: 56,
            ),
          ),
          const SizedBox(height: 16),
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: C.activity.deleteConfirmQuestion(activity.title),
                  style: TextStyle(
                    fontSize: context.text.bodyMedium?.fontSize,
                    color: context.colors.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                TextSpan(
                  text: C.activity.cannotBeUndone,
                  style: TextStyle(
                    fontSize: context.text.bodyMedium?.fontSize,
                    color: context.colors.error.withValues(alpha: 0.75),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: context.text.bodyMedium?.fontSize,
              color: context.colors.onSurface.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).maybePop();
          },
          child: Text(
            C.common.cancel,
            style: TextStyle(
              color: context.colors.onSurface.withValues(alpha: 0.6),
              fontSize: context.text.bodyLarge?.fontSize,
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            Navigator.of(context, rootNavigator: true).maybePop();
            final error = await listingController.deleteActivity(activity.id);

            if (error != null) {
              '${C.activity.deleteErrorBase}$error'.errorSnackbar();
            } else {
              C.activity.successDeleted(activity.title).successSnackbar();
            }
          },
          child: Text(
            C.common.delete,
            style: TextStyle(
              color: context.colors.error,
              fontSize: context.text.titleMedium?.fontSize,
            ),
          ),
        ),
      ],
    );
  }
}
