import 'package:flutter/material.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';

typedef C = AppConstants;

class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

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

class DualListHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  final int selectedCount;
  final int totalCount;

  const DualListHeader({
    super.key,
    required this.icon,
    required this.title,
    required this.selectedCount,
    required this.totalCount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Icon(icon, color: context.primary),
          const SizedBox(width: 10),
          Expanded(child: Text(title, style: context.text.titleLarge)),
          Text(
            '$selectedCount/$totalCount',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class DualListFooter extends StatelessWidget {
  final VoidCallback onApply;

  const DualListFooter({super.key, required this.onApply});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SizedBox(
        width: double.infinity,
        child: FilledButton.icon(
          onPressed: onApply,
          icon: const Icon(Icons.check, size: 18),
          label: Text(C.activity.apply),
        ),
      ),
    );
  }
}

class DualListPanel extends StatelessWidget {
  final String title;
  final GlobalKey<AnimatedListState> listKey;
  final int itemCount;
  final bool isCompact;
  final bool isSelectionSide;
  final Widget Function(
    BuildContext context,
    int index,
    Animation<double> animation,
  )
  itemBuilder;

  const DualListPanel({
    super.key,
    required this.title,
    required this.listKey,
    required this.itemCount,
    required this.isCompact,
    required this.isSelectionSide,
    required this.itemBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: isSelectionSide
          ? context.primary.withValues(alpha: 0.05)
          : context.colors.secondaryContainer.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: context.colors.outline.withValues(alpha: 0.05),
          width: 0.5,
        ),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedOpacity(
              opacity: isCompact ? 0.0 : 1.0,
              duration: const Duration(milliseconds: 250),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8, left: 4),
                child: Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Expanded(
              child: AnimatedList(
                key: listKey,
                initialItemCount: itemCount,
                itemBuilder: itemBuilder,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class AnimatedItemTile<T> extends StatelessWidget {
  final T item;
  final Animation<double> animation;
  final bool isCompact;
  final bool isSelectionSide;
  final VoidCallback onTap;
  final String Function(T item)? itemLabelBuilder;

  const AnimatedItemTile({
    super.key,
    required this.item,
    required this.animation,
    required this.isCompact,
    required this.isSelectionSide,
    required this.onTap,
    this.itemLabelBuilder,
  });

@override
  Widget build(BuildContext context) {
    return SizeTransition(
      key: ValueKey('transition_${item.hashCode}'),
      sizeFactor: animation,
      alignment: Alignment.center,
      child: ScaleTransition(
        scale: animation,
        child: FadeTransition(
          opacity: animation,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4),
            child: SelectorTile(
              key: ValueKey('tile_${item.hashCode}'),
              item: item,
              isCompact: isCompact,
              isSelectionSide: isSelectionSide,
              itemLabelBuilder: itemLabelBuilder,
              onTap: onTap,
            ),
          ),
        ),
      ),
    );
  }
}

class SelectorTile<T> extends StatelessWidget {
  final T item;
  final bool isCompact;
  final bool isSelectionSide;
  final VoidCallback onTap;
  final String Function(T item)? itemLabelBuilder;

  const SelectorTile({
    super.key,
    required this.item,
    required this.isCompact,
    required this.isSelectionSide,
    required this.onTap,
    this.itemLabelBuilder,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final String displayText = itemLabelBuilder != null
        ? itemLabelBuilder!(item)
        : item.toString();

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isSelectionSide
            ? colorScheme.primary
            : Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isSelectionSide
              ? Colors.transparent
              : colorScheme.outline.withValues(alpha: 0.2),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(10),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 4.0),
            child: Center(
              child: Text(
                displayText,
                maxLines: 1,
                overflow: TextOverflow.fade,
                softWrap: false,
                style: TextStyle(
                  color: isSelectionSide
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class DraggableSplitter extends StatelessWidget {
  final bool isLeftExpanded;
  final AnimationController controller;
  final double totalWidth;
  final VoidCallback onToggle;

  const DraggableSplitter({
    super.key,
    required this.isLeftExpanded,
    required this.controller,
    required this.totalWidth,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: (_) => controller.stop(),
      onHorizontalDragUpdate: (details) {
        controller.value += details.delta.dx / totalWidth;
      },
      onHorizontalDragEnd: (details) {
        if (controller.value > 0.5) {
          controller.animateTo(0.75, curve: Curves.easeOutCubic);
        } else {
          controller.animateTo(0.25, curve: Curves.easeOutCubic);
        }
      },
      onTap: onToggle,
      child: Container(
        width: 32,
        alignment: Alignment.center,
        child: Container(
          width: 4,
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
