import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/shopping_item.dart';

class CartPopupMenu extends StatelessWidget {
  const CartPopupMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final items = iMat.getShoppingCart().items;
    final total = iMat.shoppingCartTotal();

    if (items.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('Din kundvagn är tom.'),
      );
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(maxHeight: 400, maxWidth: 300),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...items.map(
              (item) => ListTile(
                dense: true,
                title: Text(item.product.name),
                subtitle: Text(
                  '${item.amount.toInt()} st • ${item.product.price.toStringAsFixed(2)} ${item.product.unit}',
                ),
                trailing: IconButton(
                  icon: const Icon(
                    Icons.remove_circle_outline,
                    color: Colors.redAccent,
                  ),
                  onPressed: () {
                    iMat.shoppingCartRemove(item);
                  },
                ),
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Totalt:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${total.toStringAsFixed(2)} kr',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
