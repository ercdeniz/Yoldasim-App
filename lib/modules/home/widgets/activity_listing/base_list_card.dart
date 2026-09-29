import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';

class BaseActivityCard extends StatelessWidget {
  final String title;
  final IconData iconData;
  final Color color;
  final ActivityStatus status;
  final List<Widget> chips;
  final VoidCallback onTap;

  const BaseActivityCard({
    super.key,
    required this.title,
    required this.iconData,
    required this.color,
    required this.status,
    required this.chips,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: context.theme.colorScheme.secondaryContainer,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SOL: İkon Kutusu
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(iconData, color: Colors.white, size: 23),
            ),

            const SizedBox(width: 14),

            // ORTA BÖLÜM: Başlık ve Çipler
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: context.theme.textTheme.titleMedium?.fontSize,
                      fontWeight: FontWeight.bold,
                      color: context.theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: chips,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),

            // SAĞ BÖLÜM: Durum Çemberi ve 3 Nokta Menüsü
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: status.bgColor,
                    border: Border.all(color: status.color, width: 1.5),
                  ),
                  child: Icon(status.icon, color: status.color, size: 16),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.more_vert,
                    size: 20,
                    color: Colors.grey,
                  ),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  onPressed: () {
                    // Menü tetikleyicisi
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
