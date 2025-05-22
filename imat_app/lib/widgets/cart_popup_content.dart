import 'package:flutter/material.dart';
import 'package:imat_app/widgets/car_item_tile.dart';
import 'package:imat_app/widgets/cart_total_row.dart';
import 'package:imat_app/widgets/close-button.dart';
import 'package:imat_app/widgets/empty_cart_message.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class CartPopupMenu extends StatelessWidget {
  final VoidCallback? onClose;

  const CartPopupMenu({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final items = iMat.getShoppingCart().items;

    if (items.isEmpty) return const EmptyCartMessage();

    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 420, maxWidth: 320),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.teal, width: 5),
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ...items.map((item) => CartItemTile(item: item)).toList(),
              const Divider(thickness: 1.5),
              const CartTotalRow(),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8, bottom: 8),
                  child: CloseButtonWidget(onPressed: onClose),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
