import 'package:flutter/material.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';

/// Aktivite istatistik çipi.
/// [value] : Çip üzerinde gösterilecek değer.
/// [color] : Çip üzerindeki yazının rengi.
/// Bu widget, aktivite kartlarının üzerinde istatistikler göstermek için kullanılır.
/// Örneğin, 2/5 gibi.
class ActivityStatChip extends StatelessWidget {
  final String value;
  final Color color;

  const ActivityStatChip({super.key, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: context.colors.secondaryContainer.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        value,
        textAlign: TextAlign.justify,
        style: TextStyle(
          fontSize: context.text.labelSmall?.fontSize,
          fontWeight: context.text.labelSmall?.fontWeight,
          color: color,
        ),
      ),
    );
  }
}
