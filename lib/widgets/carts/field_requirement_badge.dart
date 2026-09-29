import 'package:flutter/material.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';

typedef C = AppConstants;

class FieldRequirementBadge extends StatelessWidget {
  final FieldRequirement requirement;

  const FieldRequirementBadge({
    super.key,
    required this.requirement,
  });

  @override
  Widget build(BuildContext context) {
    final isOptional = requirement == FieldRequirement.optional;

    // Opsiyonel ise Sarı (Amber), Zorunlu ise Kırmızı
    final color = isOptional ? Colors.amber.shade700 : Colors.redAccent;
    final text = isOptional ? C.common.optional : C.common.mandatory;
    final bgColor = isOptional
        ? Colors.amber.withValues(alpha: 0.1)
        : Colors.redAccent.withValues(alpha: 0.1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}