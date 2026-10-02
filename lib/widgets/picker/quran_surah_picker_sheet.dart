import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';

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

    return Material(
      color: context.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.84,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 14, 20, 12),
            child: Column(
              children: [
                _DragHandle(),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Icon(Icons.menu_book_outlined, color: context.primary),
                    const SizedBox(width: 10),
                    Text(
                      C.activity.quranSurah,
                      style: context.text.titleLarge,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextField(
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
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: filteredIndexes.isEmpty
                      ? Center(child: Text(C.activity.noQuranSearchResult))
                      : ListView.separated(
                          itemCount: filteredIndexes.length,
                          separatorBuilder: (_, _) => const SizedBox(height: 6),
                          itemBuilder: (context, index) {
                            final number = filteredIndexes[index];
                            final selected = number == widget.initialSurah;
                            return ListTile(
                              tileColor: selected
                                  ? context.primary.withValues(alpha: 0.1)
                                  : context.scaffoldBackgroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              leading: CircleAvatar(
                                radius: 18,
                                backgroundColor:
                                    context.primary.withValues(alpha: 0.12),
                                child: Text(
                                  '$number',
                                  style: TextStyle(color: context.primary),
                                ),
                              ),
                              title: Text(names[number - 1]),
                              trailing: selected
                                  ? Icon(Icons.check, color: context.primary)
                                  : const Icon(Icons.chevron_right),
                              onTap: () {
                                widget.onSurahSelected(number);
                                Navigator.of(
                                  context,
                                  rootNavigator: true,
                                ).pop();
                              },
                            );
                          },
                        ),
                ),
              ],
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