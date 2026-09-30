import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/extensions/snackbar_extentions.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/modules/add_salah/controller.dart';
import 'package:yoldasim_app/modules/add_salah/widgets/fields/salah_debt_target_section.dart';
import 'package:yoldasim_app/modules/add_salah/widgets/fields/salah_time_date_section.dart';
import 'package:yoldasim_app/widgets/carts/mandatory_switch_card.dart';

typedef C = AppConstants;

class AddSalahPage extends GetView<AddSalahController> {
  const AddSalahPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(C.activity.salahTitle, style: context.text.titleLarge),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          style: IconButton.styleFrom(
            backgroundColor: Colors.grey.withValues(alpha: 0.1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          onPressed: () =>
              Navigator.of(context, rootNavigator: true).pop(),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: const Icon(Icons.check, size: 20),
              style: IconButton.styleFrom(
                backgroundColor: context.primary.withValues(alpha: 0.5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () async {
                final error = await controller.saveActivity();
                if (error != null) {
                  error.errorSnackbar();
                } else {
                  if (context.mounted) {
                    Navigator.of(context, rootNavigator: true).pop();
                  }
                  C.activity
                      .successCreated(controller.selectedTimeText.value)
                      .successSnackbar();
                }
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Card(
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const SalahDateTimeSection(),
                const SizedBox(height: 16),
                const SalahDebtTargetSection(),
                const SizedBox(height: 16),
                MandatorySwitchCard(isMandatory: controller.isDailyMandatory),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
