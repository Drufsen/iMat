import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/scalable_text.dart';
import 'package:provider/provider.dart';

class CartItemTile extends StatelessWidget {
  final ShoppingItem item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final iMat = context.read<ImatDataHandler>();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        dense: true,
        title: ScalableText(item.product.name, fontWeight: FontWeight.bold),
        subtitle: ScalableText(
          '${item.amount.toInt()} st • ${item.product.price.toStringAsFixed(2)} ${item.product.unit}',
        ),
        trailing: IconButton(
          icon: const Icon(
            Icons.remove_circle_outline,
            color: Colors.redAccent,
          ),
          onPressed: () => iMat.shoppingCartRemove(item),
        ),
      ),
    );
  }
}
