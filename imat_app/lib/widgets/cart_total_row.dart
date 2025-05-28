import 'package:flutter/material.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/scalable_text.dart';
import 'package:provider/provider.dart';

class CartTotalRow extends StatelessWidget {
  const CartTotalRow({super.key});

  @override
  Widget build(BuildContext context) {
    final total = context.watch<ImatDataHandler>().shoppingCartTotal();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const ScalableText('Totalt:', style: TextStyle(fontWeight: FontWeight.bold)),
          ScalableText(
            '${total.toStringAsFixed(2)} kr',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
