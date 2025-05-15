import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.ITColor,
      titleSpacing: 0,
      elevation: 4,
      leading: IconButton(
        onPressed: null,
        icon: const Icon(Icons.home, color: Colors.blueGrey),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Center(
          child: Container(
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
        ),
      ),
      actions: [
        IconButton(
          onPressed: null,
          icon: const Icon(Icons.favorite_border, color: Colors.amberAccent),
          hoverColor: AppTheme.colorScheme.inversePrimary,
        ),
        IconButton(
          onPressed: null,
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.teal),
        ),
        IconButton(
          onPressed: null,
          icon: const Icon(Icons.account_circle_outlined, color: Colors.teal),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 20);
}
