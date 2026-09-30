import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/extensions/snackbar_extentions.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/modules/add_fasting/controller.dart';
import 'package:yoldasim_app/modules/add_fasting/widgets/fasting_form_section.dart';
import 'package:yoldasim_app/widgets/carts/mandatory_switch_card.dart';

typedef C = AppConstants;

class AddFastingPage extends GetView<AddFastingController> {
	const AddFastingPage({super.key});

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: context.scaffoldBackgroundColor,
			appBar: AppBar(
				title: Text(C.activity.fastingTitle, style: context.text.titleLarge),
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
						padding: const EdgeInsets.all(8),
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
									return;
								}

								if (context.mounted) {
									Navigator.of(context, rootNavigator: true).pop();
								}
								C.activity
										.successCreated(C.activity.fastingTitle)
										.successSnackbar();
							},
						),
					),
				],
			),
			body: SingleChildScrollView(
				child: Card(
					margin: const EdgeInsets.all(16),
					child: Padding(
						padding: const EdgeInsets.all(16),
						child: Column(
							children: [
								const FastingFormSection(),
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
