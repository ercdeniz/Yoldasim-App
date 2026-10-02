import 'package:flutter/material.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'components/dual_list_components.dart';

/// İki farklı liste (seçilebilirler ve seçilenler) arasında animasyonlu öğe transferine
/// ve yatay olarak sürüklenebilir bir ayırıcıya (splitter) sahip, tür bağımsız (Generic) seçim alt sayfası.
///
/// [T] jenerik tipi sayesinde Integer, String veya özel veri modelleriyle çalışabilir.
/// Çoklu seçim işlemlerin daha interaktif ve görsel bir şekilde yapılmasını sağlar.
///
/// * [allItems]: Seçim havuzunda bulunacak tüm öğelerin listesi (Örn: `[1, 2, 3, ..., 30]`).
/// * [initialSelectedItems]: Ekran açıldığında sağ taraftaki (seçili) panelde yer alacak öğelerin listesi.
/// * [onItemsSelected]: 'Uygula' butonuna tıklandığında nihai seçili öğeleri `List<T>` olarak döndüren callback.
/// * [headerTitle]: Ana pencerenin üst kısmında yer alan genel başlık metni.
/// * [leftPanelTitle]: Henüz seçilmemiş öğelerin bulunduğu sol panelin başlığı.
/// * [rightPanelTitle]: Seçilen öğelerin bulunduğu sağ panelin başlığı.
/// * [headerIcon]: Üst başlığın sol tarafında gösterilecek ikon.
/// * [itemLabelBuilder]: (Opsiyonel) Görselleştirme katmanıdır. Ekranda [T] tipindeki öğenin
///   `toString()` metodu yerine özel bir metin göstermek için kullanılır (Örn: 1 değerini "Pzt" olarak göstermek).
class DualListSplitSelector<T> extends StatefulWidget {
  final List<T> allItems;
  final List<T> initialSelectedItems;
  final ValueChanged<List<T>> onItemsSelected;
  final String headerTitle;
  final String leftPanelTitle;
  final String rightPanelTitle;
  final IconData headerIcon;
  final String Function(T item)? itemLabelBuilder;

  const DualListSplitSelector({
    super.key,
    required this.allItems,
    required this.initialSelectedItems,
    required this.onItemsSelected,
    required this.headerTitle,
    required this.leftPanelTitle,
    required this.rightPanelTitle,
    required this.headerIcon,
    this.itemLabelBuilder,
  });

  @override
  State<DualListSplitSelector<T>> createState() => _DualListSplitSelectorState<T>();
}

class _DualListSplitSelectorState<T> extends State<DualListSplitSelector<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _ratioController;
  bool get _isLeftExpanded => _ratioController.value > 0.5;

  final GlobalKey<AnimatedListState> _availableListKey = GlobalKey<AnimatedListState>();
  final GlobalKey<AnimatedListState> _selectedListKey = GlobalKey<AnimatedListState>();

  late List<T> _availableItems;
  late List<T> _selectedItems;

  @override
  void initState() {
    super.initState();
    _ratioController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
      lowerBound: 0.2,
      upperBound: 0.8,
      value: 0.75,
    );

    _selectedItems = List.from(widget.initialSelectedItems);
    _sortListOriginalOrder(_selectedItems);

    final selectedSet = _selectedItems.toSet();
    _availableItems = widget.allItems
        .where((item) => !selectedSet.contains(item))
        .toList();
  }

  void _sortListOriginalOrder(List<T> list) {
    list.sort((a, b) =>
        widget.allItems.indexOf(a).compareTo(widget.allItems.indexOf(b)));
  }

  @override
  void dispose() {
    _ratioController.dispose();
    super.dispose();
  }

  void _transferItem({required T item, required bool isSelecting}) {
    final sourceItems = isSelecting ? _availableItems : _selectedItems;
    final targetItems = isSelecting ? _selectedItems : _availableItems;
    final sourceKey = isSelecting ? _availableListKey : _selectedListKey;
    final targetKey = isSelecting ? _selectedListKey : _availableListKey;

    final index = sourceItems.indexOf(item);
    if (index == -1) return;

    final removed = sourceItems.removeAt(index);

    sourceKey.currentState?.removeItem(
      index,
      (context, animation) => AnimatedItemTile<T>(
        item: removed,
        animation: animation,
        isSelectionSide: !isSelecting,
        isCompact: isSelecting ? !_isLeftExpanded : _isLeftExpanded,
        itemLabelBuilder: widget.itemLabelBuilder,
        onTap: () {}, // Çıkarılırken tıklanmasını engelle
      ),
      duration: const Duration(milliseconds: 300),
    );

    targetItems.add(removed);
    _sortListOriginalOrder(targetItems);

    targetKey.currentState?.insertItem(
      targetItems.indexOf(removed),
      duration: const Duration(milliseconds: 300),
    );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.surface,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: MediaQuery.sizeOf(context).height * 0.85),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 14, 0, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const DragHandle(),
                const SizedBox(height: 18),
                DualListHeader(
                  icon: widget.headerIcon,
                  title: widget.headerTitle,
                  selectedCount: _selectedItems.length,
                  totalCount: widget.allItems.length,
                ),
                const SizedBox(height: 18),
                Expanded(child: _buildSplitterLayout()),
                const SizedBox(height: 18),
                DualListFooter(
                  onApply: () {
                    widget.onItemsSelected([..._selectedItems]);
                    Navigator.of(context, rootNavigator: true).pop();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Ortadaki ayırıcıyı ve iki listeyi yöneten ana Layout
  Widget _buildSplitterLayout() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return AnimatedBuilder(
            animation: _ratioController,
            builder: (context, child) {
              final totalWidth = constraints.maxWidth;
              final leftWidth = totalWidth * _ratioController.value;

              return Stack(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: leftWidth,
                        child: DualListPanel(
                          title: widget.leftPanelTitle,
                          listKey: _availableListKey,
                          itemCount: _availableItems.length,
                          isCompact: !_isLeftExpanded,
                          isSelectionSide: false,
                          itemBuilder: (context, index, animation) => AnimatedItemTile<T>(
                            item: _availableItems[index],
                            animation: animation,
                            isSelectionSide: false,
                            isCompact: !_isLeftExpanded,
                            itemLabelBuilder: widget.itemLabelBuilder,
                            onTap: () => _transferItem(item: _availableItems[index], isSelecting: true),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: totalWidth - leftWidth,
                        child: DualListPanel(
                          title: widget.rightPanelTitle,
                          listKey: _selectedListKey,
                          itemCount: _selectedItems.length,
                          isCompact: _isLeftExpanded,
                          isSelectionSide: true,
                          itemBuilder: (context, index, animation) => AnimatedItemTile<T>(
                            item: _selectedItems[index],
                            animation: animation,
                            isSelectionSide: true,
                            isCompact: _isLeftExpanded,
                            itemLabelBuilder: widget.itemLabelBuilder,
                            onTap: () => _transferItem(item: _selectedItems[index], isSelecting: false),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    left: leftWidth - 16,
                    top: 0,
                    bottom: 0,
                    child: DraggableSplitter(
                      isLeftExpanded: _isLeftExpanded,
                      controller: _ratioController,
                      totalWidth: totalWidth,
                      onToggle: () {
                        final target = _isLeftExpanded ? 0.25 : 0.75;
                        _ratioController.animateTo(target, curve: Curves.easeOutCubic);
                      },
                    ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}