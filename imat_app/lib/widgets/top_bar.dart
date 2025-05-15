import 'package:flutter/material.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      elevation: 4,
      leading: IconButton(
        onPressed: null,
        icon: const Icon(Icons.home, color: Colors.blueGrey),
      ),
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: Colors.blueAccent,
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
      actions: [
        IconButton(
          onPressed: null,
          icon: const Icon(Icons.favorite_border, color: Colors.amberAccent),
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
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
