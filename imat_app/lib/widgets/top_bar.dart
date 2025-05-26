import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/Controller/cart_overlay_controller.dart';
import 'package:imat_app/model/Controller/settings_controller.dart';
import 'package:imat_app/widgets/OrderHistoryModalState.dart';

class TopBar extends StatefulWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _TopBarState extends State<TopBar> {
  final GlobalKey _cartIconKey = GlobalKey();
  final GlobalKey _settingsIconKey = GlobalKey();
  late CartOverlayController _cartOverlayController;
  late SettingsOverlayController _settingsOverlayController;

  void _showTransactionHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const OrderHistoryModal();
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _cartOverlayController = CartOverlayController();
    _settingsOverlayController = SettingsOverlayController();
  }

  @override
  void dispose() {
    _cartOverlayController.removeCartPopup();
    _settingsOverlayController.removeSettingsPopup();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      backgroundColor: AppTheme.colorScheme.primary,
      titleSpacing: 10,
      elevation: 4,
      leading: null,
      leadingWidth: 0,
      title: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 40),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.home,
                    color: Colors.tealAccent,
                    size: 35,
                  ),
                  padding: EdgeInsets.zero,
                ),
                const SizedBox(width: 8),
                const Text(
                  'iMat',
                  style: TextStyle(
                    color: Colors.tealAccent,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          const Expanded(
            child: Center(
              child: SizedBox(
                height: 40,
                width: 500,
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Sök efter produkter...',
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: EdgeInsets.zero,
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
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
                key: _settingsIconKey,
                onPressed:
                    () => _settingsOverlayController.toggleSettingsPopup(
                      context,
                      _settingsIconKey,
                    ),
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
