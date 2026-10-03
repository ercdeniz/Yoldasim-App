
// sure listesi
import 'package:flutter/material.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/modules/add_quran/widgets/quran_surah_picker/quran_surah_picker_sheet.dart';

class SurahList extends StatelessWidget {
  const SurahList({
    super.key,
    required this.filteredIndexes,
    required this.widget,
    required this.names,
  });

  final List<int> filteredIndexes;
  final QuranSurahPickerSheet widget;
  final List<String> names;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ClipRect(
        child: filteredIndexes.isEmpty
            ? Center(child: Text(C.activity.noQuranSearchResult))
            : ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                itemCount: filteredIndexes.length,
                separatorBuilder: (_, _) => const SizedBox(height: 6),
                itemBuilder: (context, index) {
                  final number = filteredIndexes[index];
                  final selected = number == widget.initialSurah;

                  return listItem(selected, context, number);
                },
              ),
      ),
    );
  }

  // tek bir surenin listelenmesi için widget
  Material listItem(bool selected, BuildContext context, int number) {
    return Material(
      color: selected
          ? context.primary.withValues(alpha: 0.1)
          : context.scaffoldBackgroundColor,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        leading: CircleAvatar(
          radius: 18,
          backgroundColor: context.primary.withValues(alpha: 0.12),
          child: Text('$number', style: TextStyle(color: context.primary)),
        ),
        title: Text(names[number - 1]),
        trailing: selected
            ? Icon(Icons.check, color: context.primary)
            : const Icon(Icons.chevron_right),
        onTap: () {
          widget.onSurahSelected(number);
          Navigator.of(context, rootNavigator: true).pop();
        },
      ),
    );
  }
}
