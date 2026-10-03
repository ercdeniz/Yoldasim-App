import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/modules/add_quran/widgets/quran_surah_picker/components/surah_list.dart';
import 'package:yoldasim_app/widgets/utils/drag_hendle.dart';

typedef C = AppConstants;

class QuranSurahPickerSheet extends StatefulWidget {
  final int initialSurah;
  final ValueChanged<int> onSurahSelected;

  const QuranSurahPickerSheet({
    super.key,
    required this.initialSurah,
    required this.onSurahSelected,
  });

  static void show({
    required int initialSurah,
    required ValueChanged<int> onSurahSelected,
  }) {
    Get.bottomSheet(
      QuranSurahPickerSheet(
        initialSurah: initialSurah,
        onSurahSelected: onSurahSelected,
      ),
      isScrollControlled: true,
    );
  }

  @override
  State<QuranSurahPickerSheet> createState() => _QuranSurahPickerSheetState();
}

class _QuranSurahPickerSheetState extends State<QuranSurahPickerSheet> {
  late final TextEditingController searchController;
  String query = '';

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final names = C.activity.quranSurahNames;
    final filteredIndexes = List.generate(names.length, (index) => index + 1)
        .where(
          (number) => names[number - 1].toLowerCase().contains(
            query.trim().toLowerCase(),
          ),
        )
        .toList();

    // --- DİNAMİK YÜKSEKLİK VE KLAVYE SINIRI ---
    final screenHeight = MediaQuery.sizeOf(context).height;
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;
    final statusBarHeight = MediaQuery.paddingOf(context).top;
    final maxAllowedHeight =
        screenHeight - keyboardHeight - statusBarHeight - kToolbarHeight;
    final sheetHeight = (screenHeight * 0.84).clamp(0.0, maxAllowedHeight);

    return Material(
      color: context.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      clipBehavior: Clip.antiAlias,
      child: SafeArea(
        child: SizedBox(
          height: sheetHeight,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const DragHandle(),
                    const SizedBox(height: 18),
                    _title(context),
                    const SizedBox(height: 16),
                    _search(context),
                  ],
                ),
              ),
              // sure listesi
              SurahList(
                filteredIndexes: filteredIndexes,
                widget: widget,
                names: names,
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextField _search(BuildContext context) {
    return TextField(
      controller: searchController,
      autofocus: true,
      onChanged: (value) => setState(() => query = value),
      decoration: InputDecoration(
        hintText: C.activity.searchQuranSurah,
        prefixIcon: const Icon(Icons.search),
        suffixIcon: query.isEmpty
            ? null
            : IconButton(
                onPressed: () {
                  searchController.clear();
                  setState(() => query = '');
                },
                icon: const Icon(Icons.clear),
              ),
        filled: true,
        fillColor: context.scaffoldBackgroundColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Row _title(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(C.activity.selectQuranSurah, style: context.text.titleLarge),
      ],
    );
  }
}
