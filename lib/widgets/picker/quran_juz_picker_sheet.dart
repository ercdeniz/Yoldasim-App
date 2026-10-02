import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';

typedef C = AppConstants;

class QuranJuzPickerSheet extends StatelessWidget {
  final List<int> initialJuzNumbers;
  final ValueChanged<List<int>> onJuzSelected;

  const QuranJuzPickerSheet({
    super.key,
    required this.initialJuzNumbers,
    required this.onJuzSelected,
  });

  static void show({
    required List<int> initialJuzNumbers,
    required ValueChanged<List<int>> onJuzSelected,
  }) {
    Get.bottomSheet(
      QuranJuzPickerSheet(
        initialJuzNumbers: initialJuzNumbers,
        onJuzSelected: onJuzSelected,
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedJuzNumbers = initialJuzNumbers.obs;

    return Material(
      color: context.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.75,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DragHandle(),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Icon(Icons.format_list_numbered, color: context.primary),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          C.activity.quranJuz,
                          style: context.text.titleLarge,
                        ),
                      ),
                      Obx(
                        () => Text(
                          '${selectedJuzNumbers.length}/30',
                          style: TextStyle(
                            color: context.text.bodyMedium?.color,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Obx(() {
                    final selectedJuz = selectedJuzNumbers.toSet();
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: 30,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 5,
                            mainAxisSpacing: 10,
                            crossAxisSpacing: 10,
                            childAspectRatio: 1.25,
                          ),
                      itemBuilder: (context, index) {
                        final number = index + 1;
                        return _JuzTile(
                          number: number,
                          selected: selectedJuz.contains(number),
                          onTap: () {
                            if (selectedJuz.contains(number)) {
                              selectedJuzNumbers.remove(number);
                            } else {
                              selectedJuzNumbers.add(number);
                            }
                            selectedJuzNumbers.sort();
                          },
                        );
                      },
                    );
                  }),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        onJuzSelected([...selectedJuzNumbers]);
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      icon: const Icon(Icons.check, size: 18),
                      label: Text(C.activity.apply),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _JuzTile extends StatelessWidget {
  final int number;
  final bool selected;
  final VoidCallback onTap;

  const _JuzTile({
    required this.number,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: selected ? colorScheme.primary : context.scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Center(
          child: Text(
            "$number",
            style: TextStyle(
              color: selected ? colorScheme.onPrimary : context.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
