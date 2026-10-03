import 'package:flutter/material.dart';

/// Sayfanın en üstünde yer alan, paneli aşağı kaydırma hissiyatı veren görsel çubuktur.
class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade400,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}