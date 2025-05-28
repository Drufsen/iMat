import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/scalable_text.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class AddToCartButton extends StatefulWidget {
  final Product product;

  const AddToCartButton({super.key, required this.product});

  @override
  State<AddToCartButton> createState() => _AddToCartButtonState();
}

class _AddToCartButtonState extends State<AddToCartButton> {
  double _amount = 0;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final iMat = context.watch<ImatDataHandler>();
    final item = iMat.getShoppingCart().items.cast<ShoppingItem?>().firstWhere(
      (i) => i!.product.productId == widget.product.productId,
      orElse: () => null,
    );
    if (item != null) {
      _amount = item.amount;
    }
  }

  void _increase() {
    final iMat = context.read<ImatDataHandler>();
    iMat.shoppingCartAdd(ShoppingItem(widget.product, amount: 1));
    setState(() => _amount++);
  }

  void _decrease() {
    final iMat = context.read<ImatDataHandler>();
    iMat.shoppingCartAdd(ShoppingItem(widget.product, amount: -1));
    setState(() {
      _amount--;
      if (_amount < 0) {
        _amount = 0;
      } else if (_amount == 0) {
        iMat.shoppingCartRemove(ShoppingItem(widget.product, amount: 0));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_amount == 0) {
      return ElevatedButton.icon(
        onPressed: _increase,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.teal,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
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
          color: Colors.white, // Ljus bakgrund
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Minus-knapp
            InkWell(
              onTap: _decrease,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.teal.shade100, // Ljusgrön
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
                '$_amount',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Plus-knapp
            InkWell(
              onTap: _increase,
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
