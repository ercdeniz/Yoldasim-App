import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';

typedef C = AppConstants;

class ActivitySchedulePickerSheet extends StatelessWidget {
  final ActivityPeriod period;
  final List<int> initialWeeklyDays;
  final List<int> initialMonthlyDays;
  final ValueChanged<List<int>> onWeeklyDaysSelected;
  final ValueChanged<List<int>> onMonthlyDaysSelected;

  const ActivitySchedulePickerSheet({
    super.key,
    required this.period,
    required this.initialWeeklyDays,
    required this.initialMonthlyDays,
    required this.onWeeklyDaysSelected,
    required this.onMonthlyDaysSelected,
  });

  static void show({
    required ActivityPeriod period,
    required List<int> initialWeeklyDays,
    required List<int> initialMonthlyDays,
    required ValueChanged<List<int>> onWeeklyDaysSelected,
    required ValueChanged<List<int>> onMonthlyDaysSelected,
  }) {
    Get.bottomSheet(
      ActivitySchedulePickerSheet(
        period: period,
        initialWeeklyDays: initialWeeklyDays,
        initialMonthlyDays: initialMonthlyDays,
        onWeeklyDaysSelected: onWeeklyDaysSelected,
        onMonthlyDaysSelected: onMonthlyDaysSelected,
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    final weeklyDays = initialWeeklyDays.obs;
    final monthlyDays = initialMonthlyDays.obs;

    return Material(
      color: context.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.sizeOf(context).height * 0.85,
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _DragHandle(),
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: context.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(13),
                        ),
                        child: Icon(
                          period == ActivityPeriod.weekly
                              ? Icons.view_week_outlined
                              : Icons.calendar_month_outlined,
                          color: context.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          C.activity.scheduledDays,
                          style: context.text.titleLarge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  if (period == ActivityPeriod.weekly)
                    _WeeklyPicker(weeklyDays: weeklyDays)
                  else
                    _MonthlyPicker(monthlyDays: monthlyDays),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () {
                        if (period == ActivityPeriod.weekly) {
                          onWeeklyDaysSelected([...weeklyDays]);
                        } else {
                          onMonthlyDaysSelected([...monthlyDays]);
                        }
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

class _WeeklyPicker extends StatelessWidget {
  final RxList<int> weeklyDays;

  const _WeeklyPicker({required this.weeklyDays});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedDays = weeklyDays.toSet();

      return Column(
        children: [
          _QuickActions(
            onSelectAll: () => weeklyDays.assignAll(List.generate(7, (i) => i + 1)),
            onClear: weeklyDays.clear,
          ),
          const SizedBox(height: 14),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 1.35,
            ),
            itemCount: 7,
            itemBuilder: (context, index) {
              final day = index + 1;
              return _DayTile(
                label: C.shortDaysOfWeek[index],
                selected: selectedDays.contains(day),
                onTap: () {
                  if (selectedDays.contains(day)) {
                    weeklyDays.remove(day);
                  } else {
                    weeklyDays.add(day);
                  }
                  weeklyDays.sort();
                },
              );
            },
          ),
        ],
      );
    });
  }
}

class _MonthlyPicker extends StatelessWidget {
  final RxList<int> monthlyDays;

  const _MonthlyPicker({required this.monthlyDays});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final selectedDays = monthlyDays.toSet();

      return Column(
        children: [
          _QuickActions(
            onSelectAll: () =>
                monthlyDays.assignAll(List.generate(31, (index) => index + 1)),
            onClear: monthlyDays.clear,
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceContainerHighest
                  .withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(16),
            ),
            child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 1,
            ),
            itemCount: 31,
            itemBuilder: (context, index) {
              final day = index + 1;
              return _DayTile(
                label: '$day',
                selected: selectedDays.contains(day),
                compact: true,
                onTap: () {
                  if (selectedDays.contains(day)) {
                    monthlyDays.remove(day);
                  } else {
                    monthlyDays.add(day);
                  }
                  monthlyDays.sort();
                },
              );
            },
            ),
          ),
        ],
      );
    });
  }
}

class _QuickActions extends StatelessWidget {
  final VoidCallback onSelectAll;
  final VoidCallback onClear;

  const _QuickActions({required this.onSelectAll, required this.onClear});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: onSelectAll,
            icon: const Icon(Icons.done_all, size: 17),
            label: Text(C.activity.allDays),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: TextButton.icon(
            onPressed: onClear,
            icon: const Icon(Icons.remove_done, size: 17),
            label: Text(C.activity.clearDays),
          ),
        ),
      ],
    );
  }
}

class _DayTile extends StatelessWidget {
  final String label;
  final bool selected;
  final bool compact;
  final VoidCallback onTap;

  const _DayTile({
    required this.label,
    required this.selected,
    required this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: selected
          ? colorScheme.primary
          : colorScheme.surface.withValues(alpha: 0.75),
      borderRadius: BorderRadius.circular(compact ? 9 : 13),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(compact ? 9 : 13),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(compact ? 9 : 13),
            border: Border.all(
              color: selected
                  ? colorScheme.primary
                  : colorScheme.outline.withValues(alpha: 0.25),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: TextStyle(
              color: selected ? colorScheme.onPrimary : colorScheme.onSurface,
              fontSize: compact ? 13 : 14,
              fontWeight: selected ? FontWeight.bold : FontWeight.w600,
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