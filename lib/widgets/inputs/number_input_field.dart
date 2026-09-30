import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yoldasim_app/core/constants/app_enums.dart';
import 'package:yoldasim_app/core/extensions/theme_extentions.dart';
import 'package:yoldasim_app/widgets/carts/field_requirement_badge.dart';


// TODO boşluğa tıklayınca klavyenin kapanması için bişi yap
class NumberInputField extends StatelessWidget {
  final String label;
  final String hint;
  final FieldRequirement requirement;
  final Function(String) onChanged;
  final RxBool isError;
  final Widget? trailing;

  const NumberInputField({
    super.key,
    required this.label,
    required this.hint,
    required this.requirement,
    required this.onChanged,
    required this.isError,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // LABEL VE ZORUNLULUK ROZETİ
            Padding(
              padding: const EdgeInsets.only(
                left: 4.0,
                bottom: 8.0,
                right: 4.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: context.text.bodyMedium?.fontSize,
                        fontWeight:
                            context.text.bodyMedium?.fontWeight,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: FieldRequirementBadge(requirement: requirement),
                  ),
                ],
              ),
            ),

            // SAYI GİRİŞ ALANI
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Obx(
                    () => TextFormField(
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        FilteringTextInputFormatter.deny(RegExp(r'^0+')),
                      ],
                      onChanged: onChanged,
                      decoration: InputDecoration(
                        hintText: hint,
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: isError.value
                                ? Colors.redAccent
                                : Colors.transparent,
                            width: 2.0,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: isError.value
                                ? Colors.redAccent
                                : context.primary,
                            width: 2.0,
                          ),
                          borderRadius: const BorderRadius.all(
                            Radius.circular(8.0),
                          ),
                        ),
                        errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.redAccent,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        filled: true,
                        fillColor: context.scaffoldBackgroundColor
                            .withValues(alpha: 0.5),
                      ),
                    ),
                  ),
                ),

                if (trailing != null) ...[const SizedBox(width: 8), trailing!],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
