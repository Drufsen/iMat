import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class CartItemCounter extends StatelessWidget {
  final ShoppingItem item;
  final ImatDataHandler iMat;

  const CartItemCounter({super.key, required this.item, required this.iMat});

  @override
  Widget build(BuildContext context) {
    final product = item.product;
    final amount = item.amount;

    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.teal, width: 1.5),
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Minus
          IconButton(
            icon: const Icon(Icons.remove, size: 16),
            onPressed: () {
              if (amount <= 1) {
                iMat.shoppingCartRemove(item);
              } else {
                iMat.shoppingCartAdd(ShoppingItem(product, amount: -1));
              }
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
            color: Colors.teal,
          ),

          // Antal
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '${amount.toInt()}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),

          // Plus
          IconButton(
            icon: const Icon(Icons.add, size: 16),
            onPressed: () {
              iMat.shoppingCartAdd(ShoppingItem(product, amount: 1));
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(width: 32, height: 32),
            color: Colors.teal,
          ),
        ],
      ),
    );
  }
}
