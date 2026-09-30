import 'package:flutter/material.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/widgets/carts/field_requirement_badge.dart';

class AddPageListItem extends StatelessWidget {
  final String title;
  final Widget subtitle;
  final FieldRequirement requirement;
  final IconData icon;
  final Color iconBGColor;
  final VoidCallback onTap;

  const AddPageListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.requirement,
    required this.icon,
    required this.iconBGColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Row(
          children: [
            // SOL İKON BÖLÜMÜ (Leading)
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: iconBGColor,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, size: 20, color: Colors.white),
            ),

            const SizedBox(width: 12),
            // ORTA BÖLÜM
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize:
                                context.text.bodyMedium?.fontSize,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      FieldRequirementBadge(requirement: requirement),
                    ],
                  ),
                  SizedBox(height: 4),
                  subtitle,
                ],
              ),
            ),

            const SizedBox(width: 8),

            // SAĞ İKON BÖLÜMÜ (Trailing)
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}
