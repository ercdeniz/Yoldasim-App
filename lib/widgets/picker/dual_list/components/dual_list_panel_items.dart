import 'package:flutter/material.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';

typedef C = AppConstants;

/// Ana başlık, ikon ve seçili/toplam öğe sayısını gösteren üst bilgi şerididir.
///
/// * [icon]: Başlığın solundaki ikon.
/// * [title]: Ana başlık metni.
/// * [selectedCount]: Güncel seçilen öğe sayısı.
/// * [totalCount]: Havuzdaki toplam öğe sayısı.
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

/// Tıklandığında güncel listeyi dışarı aktarıp ekranı kapatan onay butonudur.
///
/// * [onApply]: Butona tıklandığında tetiklenecek fonksiyon.
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

/// İçine listeleri alan, genişliğe göre başlığını gizleyebilen çerçeve kutusudur.
///
/// * [title]: Panelin başlığı.
/// * [listKey]: İçindeki AnimatedList'in anahtarı.
/// * [itemCount]: Başlangıçtaki öğe sayısı.
/// * [isCompact]: Panelin daraltılmış olma durumu (true ise başlık gizlenir).
/// * [isSelectionSide]: Panelin sağ (seçili) taraf olup olmadığı.
/// * [itemBuilder]: Listedeki öğeleri çizen fonksiyon.
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
              duration: Duration(milliseconds: C.common.animationDuration),
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
