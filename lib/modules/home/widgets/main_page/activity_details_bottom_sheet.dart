import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/data/models/activity_model.dart';
import 'package:yoldasim_app/modules/home/widgets/activity_listing/activity_delete_dialog.dart';

class ActivityDetailsBottomSheet extends StatelessWidget {
  final ActivityModel activity;
  final String iconPath;
  final Color color;

  const ActivityDetailsBottomSheet({
    super.key,
    required this.activity,
    required this.iconPath,
    required this.color,
  });

  static void show({
    required ActivityModel activity,
    required String iconPath,
    required Color color,
  }) {
    Get.bottomSheet(
      ActivityDetailsBottomSheet(
        activity: activity,
        iconPath: iconPath,
        color: color,
      ),
      isScrollControlled: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: context.scaffoldBackgroundColor,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(height: 16),

              // HEADER BÖLÜMÜ
              Row(
                children: [
                  // Sol İkon
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        iconPath,
                        width: 32,
                        height: 32,
                        colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),

                  // Orta Başlık
                  Expanded(
                    child: Text(
                      activity.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  // Sağ Kapatma Butonu
                  IconButton(
                    onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
                    icon: const Icon(Icons.close, color: Colors.grey),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.grey.withValues(alpha: 0.1),
                    ),
                  ),
                ],
              ),

              Divider(
                height: 32,
                color: Colors.grey.withValues(alpha: 0.1),
                indent: 5,
                endIndent: 10,
              ),

              // SEÇENEKLER BÖLÜMÜ
              _buildMenuItem(
                icon: Icons.bar_chart_rounded,
                text: C.common.statistics,
                color: Colors.blue,
                onTap: () {
                  // TODO: aktiviteye özel istatistik sayfasına yönlendir
                },
              ),
              _buildMenuItem(
                icon: Icons.edit_rounded,
                text: C.common.edit,
                color: Colors.orange,
                onTap: () {
                  // TODO: Düzenleme sayfası aç
                },
              ),
              _buildMenuItem(
                icon: Icons.delete_outline_rounded,
                text: C.common.delete,
                color: Colors.red,
                isDestructive: true,
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pop();
                  ActivityDeleteDialog.show(activity: activity);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  ListTile _buildMenuItem({
    required IconData icon,
    required String text,
    required Color color,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        text,
        style: TextStyle(
          color: isDestructive ? Colors.red : null,
          fontWeight: FontWeight.w600,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      hoverColor: color.withValues(alpha: 0.1),
    );
  }
}
