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

    return ElevatedButton.icon(
      onPressed: () {
        iMat.shoppingCartAdd(ShoppingItem(product, amount: 1));

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: ScalableText('${product.name} har lagts till i kundvagnen.'),
            duration: const Duration(seconds: 2),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal,
        foregroundColor: AppTheme.colorScheme.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      ),
      icon: const Icon(Icons.add_shopping_cart),
      label: const ScalableText("Lägg till"),
    );
  }
}
