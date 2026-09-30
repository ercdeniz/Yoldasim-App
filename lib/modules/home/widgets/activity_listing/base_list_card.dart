import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/data/models/activity_model.dart';
import 'package:yoldasim_app/modules/home/widgets/home/activity_details_bottom_sheet.dart';

class BaseActivityCard extends StatelessWidget {
  final ActivityModel activity;
  final String iconPath;
  final Color color;
  final ActivityStatus status;
  final List<Widget> chips;
  final VoidCallback onTap;

  const BaseActivityCard({
    super.key,
    required this.activity,
    required this.iconPath,
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
          color: context.colors.secondaryContainer,
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
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: SvgPicture.asset(
                  iconPath,
                  width: 40,
                  height: 40,
                  colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                ),
              ),
            ),

            const SizedBox(width: 14),

            // ORTA BÖLÜM: Başlık ve Çipler
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    activity.title,
                    style: TextStyle(
                      fontSize: context.text.titleMedium?.fontSize,
                      fontWeight: FontWeight.bold,
                      color: context.text.bodyLarge?.color,
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
                    ActivityDetailsBottomSheet.show(
                      activity: activity,
                      iconPath: iconPath,
                      color: color,
                    );
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
