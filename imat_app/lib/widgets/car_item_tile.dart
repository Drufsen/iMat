import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/shopping_item.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/cart_item_counter.dart';
import 'package:imat_app/widgets/scalable_text.dart';
import 'package:provider/provider.dart';

class CartItemTile extends StatelessWidget {
  final ShoppingItem item;

  const CartItemTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final iMat = context.read<ImatDataHandler>();
    final cleanUnit = item.product.unit.replaceFirst("kr/", "");

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8.0),
        leading: SizedBox(
          width: 40,
          height: 40,
          child: iMat.getImage(item.product),
        ),
        title: ScalableText(item.product.name, fontWeight: FontWeight.bold),
        subtitle: ScalableText(
          '${item.amount.toInt()} $cleanUnit • ${item.product.price.toStringAsFixed(2)} ${item.product.unit}',
        ),
        trailing: CartItemCounter(item: item, iMat: iMat),
      ),
    );
  }
}
