import 'package:flutter/material.dart';
import 'package:yoldasim_app/core/constants/app_constants.dart';

typedef C = AppConstants;

/// İki panel arasında sağa/sola sürüklenerek genişlik oranını ayarlayan hareketli çubuktur.
///
/// * [isLeftExpanded]: Sol panelin genişletilmiş olup olmadığı.
/// * [controller]: Panellerin genişliğini yöneten animasyon kontrolcüsü.
/// * [totalWidth]: Ekranın toplam genişliği.
class DraggableSplitter extends StatelessWidget {
  final bool isLeftExpanded;
  final AnimationController controller;
  final double totalWidth;

  const DraggableSplitter({
    super.key,
    required this.isLeftExpanded,
    required this.controller,
    required this.totalWidth,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onHorizontalDragStart: (_) => controller.stop(),
      onHorizontalDragUpdate: (details) {
        controller.value += details.delta.dx / totalWidth;
      },
      onHorizontalDragEnd: (details) {
        // Kullanıcının parmağını çekerken oluşturduğu yatay hız
        final visualVelocity = details.velocity.pixelsPerSecond.dx;

        // Hızlıca sağa fırlatıldıysa direkt sağa gönder
        if (visualVelocity > C.common.animationDuration) {
          controller.animateTo(0.8, curve: Curves.easeOutCubic);
        }
        // Hızlıca sola fırlatıldıysa direkt sola gönder
        else if (visualVelocity < -C.common.animationDuration) {
          controller.animateTo(0.2, curve: Curves.easeOutCubic);
        }
        // Yavaşça bırakıldıysa konumuna bak ve en yakın konuma gönder
        else {
          if (controller.value > 0.5) {
            controller.animateTo(0.8, curve: Curves.easeOutCubic);
          } else {
            controller.animateTo(0.2, curve: Curves.easeOutCubic);
          }
        }
      },
      child: Container(
        width: 32,
        alignment: Alignment.center,
        child: Container(
          width: 4,
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}
