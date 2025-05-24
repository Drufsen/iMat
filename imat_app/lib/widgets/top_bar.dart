import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/Controller/cart_overlay_controller.dart';
import 'package:imat_app/widgets/transaction_history_modal.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopBarState extends State<TopBar> {
  final GlobalKey _cartIconKey = GlobalKey();
  late CartOverlayController _cartOverlayController;

  void _showTransactionHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const TransactionHistoryModal();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _cartOverlayController = CartOverlayController();
  }

  @override
  void dispose() {
    _cartOverlayController.removeCartPopup();
    super.dispose();
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
          onPressed: () {},
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
              ),
              const SizedBox(width: 16), // Add spacing here
              IconButton(
                key: _cartIconKey,
                icon: const Icon(
                  Icons.shopping_cart_outlined,
                  color: Colors.tealAccent,
                  size: 35,
                ),
                onPressed:
                    () => _cartOverlayController.toggleCartPopup(
                      context,
                      _cartIconKey,
                    ),
              ),
              const SizedBox(width: 16), // Add spacing here
              IconButton(
                onPressed: () => _showTransactionHistory(context),
                icon: const Icon(
                  Icons.receipt_long,
                  color: Colors.tealAccent,
                  size: 35,
                ),
              ),
              const SizedBox(width: 16), // Add spacing here
              IconButton(
                onPressed: () {
                  // Add settings functionality here
                },
                icon: const Icon(
                  Icons.settings,
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
