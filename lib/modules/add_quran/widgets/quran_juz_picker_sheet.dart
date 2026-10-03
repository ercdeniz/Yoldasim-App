import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/widgets/picker/dual_list/dual_list_split_selector.dart';

class QuranJuzPickerSheet {
  static void show({
    required List<int> initialJuzNumbers,
    required ValueChanged<List<int>> onJuzSelected,
  }) {
    Get.bottomSheet(
      DualListSplitSelector<int>(
        allItems: List.generate(30, (i) => i + 1),
        initialSelectedItems: initialJuzNumbers,
        onItemsSelected: onJuzSelected,
        headerTitle: C.activity.selectQuranJuz,
        leftPanelTitle: C.activity.quranJuzList,
        rightPanelTitle: C.activity.detailSelectedJuz,
        headerIcon: Icons.format_list_numbered,
      ),
      isScrollControlled: true,
    );
  }
}
