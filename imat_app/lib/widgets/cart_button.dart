import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/scalable_text.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/Controller/cart_overlay_controller.dart';

class CartIconWithBadge extends StatelessWidget {
  final GlobalKey targetKey;
  final CartOverlayController controller;

  const CartIconWithBadge({
    super.key,
    required this.targetKey,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final totalQuantity =
        context.watch<ImatDataHandler>().getTotalCartQuantity();

    return Stack(
      clipBehavior: Clip.none,
      children: [
        IconButton(
          key: targetKey,
          icon: const Icon(
            Icons.shopping_cart_outlined,
            color: Colors.tealAccent,
            size: 35,
          ),
          onPressed: () => controller.toggleCartPopup(context, targetKey),
        ),
        if (totalQuantity > 0)
          Positioned(
            top: 4,
            right: 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.redAccent,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: ScalableText(
                totalQuantity.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
