import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/cart_popup_content.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopBarState extends State<TopBar> {
  final GlobalKey _cartIconKey = GlobalKey();
  OverlayEntry? _cartOverlay;

  void _toggleCartPopup() {
    if (_cartOverlay != null) {
      _removeCartPopup();
      return;
    }

    final RenderBox button =
        _cartIconKey.currentContext!.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(
      Offset.zero,
      ancestor: overlay,
    );
    final Size buttonSize = button.size;

    const double popupWidth = 320;
    double left = position.dx;
    final double screenWidth = overlay.size.width;

    // Shift left if popup would overflow off-screen
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
                    onTap: _removeCartPopup,
                    child: Container(
                      width: overlay.size.width,
                      height: overlay.size.height,
                      color: Colors.transparent,
                    ),
                  ),
                  CartPopupMenu(onClose: _removeCartPopup),
                ],
              ),
            ),
          ),
    );

    Overlay.of(context).insert(_cartOverlay!);
  }

  void _removeCartPopup() {
    _cartOverlay?.remove();
    _cartOverlay = null;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: AppTheme.colorScheme.primary,
      titleSpacing: 10,
      elevation: 4,
      leading: Padding(
        padding: const EdgeInsets.only(left: 40),
        child: IconButton(
          onPressed: () {
            // You can implement a go-home navigation here
          },
          icon: const Icon(Icons.home, color: Colors.tealAccent, size: 35),
        ),
      ),
      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 40,
            width: 500,
            decoration: BoxDecoration(
              color: AppTheme.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: 'Sök efter produkter...',
                border: InputBorder.none,
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.favorite_outlined,
                  color: Colors.tealAccent,
                  size: 35,
                ),
                hoverColor: AppTheme.colorScheme.inversePrimary,
              ),
              IconButton(
                key: _cartIconKey,
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.tealAccent,
                  size: 35,
                ),
                onPressed: _toggleCartPopup,
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.account_circle_outlined,
                  color: Colors.tealAccent,
                  size: 35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
