import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/scalable_text.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class AddToCartButton extends StatelessWidget {
  final Product product;

  const AddToCartButton({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();

    ShoppingItem? item;
    try {
      item = iMat.getShoppingCart().items.firstWhere(
        (i) => i.product.productId == product.productId,
      );
    } catch (_) {
      item = null;
    }

    final double currentAmount = item?.amount ?? 0;

    if (currentAmount == 0) {
      return ElevatedButton.icon(
        onPressed: () {
          iMat.shoppingCartAdd(ShoppingItem(product, amount: 1));
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        ),
        icon: const Icon(Icons.add_shopping_cart),
        label: const ScalableText("Lägg till"),
      );
    } else {
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.teal, width: 2),
          borderRadius: BorderRadius.circular(30),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Minus-knapp
            InkWell(
              onTap: () {
                if (currentAmount <= 1) {
                  iMat.shoppingCartRemove(ShoppingItem(product, amount: 0));
                } else {
                  iMat.shoppingCartAdd(ShoppingItem(product, amount: -1));
                }
              },

              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.remove, color: Colors.teal),
              ),
            ),
            const SizedBox(width: 12),

            // Antal
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.teal, width: 1),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '${currentAmount.toInt()}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Plus-knapp
            InkWell(
              onTap: () {
                iMat.shoppingCartAdd(ShoppingItem(product, amount: 1));
              },
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.teal.shade100,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.teal),
              ),
            ),
          ],
        ),
      );
    }
  }
}
