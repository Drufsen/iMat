import 'package:flutter/material.dart';
import 'package:imat_app/widgets/cart_popup_content.dart';

class CartOverlayController {
  OverlayEntry? _cartOverlay;

  void toggleCartPopup(BuildContext context, GlobalKey targetKey) {
    if (_cartOverlay != null) {
      removeCartPopup();
      return;
    }

    final RenderBox button =
        targetKey.currentContext!.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );
    final Size buttonSize = button.size;

    const double popupWidth = 320;
    double left = position.dx;
    final double screenWidth = overlay.size.width;

    if (left + popupWidth > screenWidth) {
      left = screenWidth - popupWidth - 8;
    }

    _cartOverlay = OverlayEntry(
      builder:
          (context) => Positioned(
            left: left,
            top: position.dy + buttonSize.height + 8,
            child: Material(
              color: Colors.transparent,
              child: Stack(
                children: [
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: removeCartPopup,
                    child: Container(
                      width: screenWidth,
                      height: overlay.size.height,
                      color: Colors.transparent,
                    ),
                  ),
                  CartPopupMenu(onClose: removeCartPopup),
                ],
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_cartOverlay!);
  }

  void removeCartPopup() {
    _cartOverlay?.remove();
    _cartOverlay = null;
  }
}
