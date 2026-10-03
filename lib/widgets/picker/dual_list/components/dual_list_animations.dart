import 'package:flutter/material.dart';

/// Öğelerin silinme ve eklenme animasyonlarını (Scale, Fade) yöneten sarmalayıcıdır.
///
/// * [item]: Çizilecek öğe.
/// * [animation]: Animasyonun mevcut durumu.
/// * [isCompact]: Kartın daraltılmış panelde olup olmadığı.
/// * [isSelectionSide]: Kartın sağ tarafta olup olmadığı.
/// * [onTap]: Karta tıklanma olayı.
/// * [itemLabelBuilder]: Öğeyi özel metinle formatlama fonksiyonu.
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

/// Listedeki tekil kartı (metin, renk, tıklanma) oluşturan görsel bileşendir.
///
/// * [item]: Gösterilecek öğe.
/// * [isCompact]: Kartın daraltılmış boyutta çizilip çizilmeyeceği.
/// * [isSelectionSide]: Arka plan ve yazı rengini belirleyen konum durumu.
/// * [onTap]: Karta tıklanma olayı.
/// * [itemLabelBuilder]: Öğeyi özel metinle formatlama fonksiyonu.
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
            padding: const EdgeInsets.symmetric(
              vertical: 12.0,
              horizontal: 4.0,
            ),
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
