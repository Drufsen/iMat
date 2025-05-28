import 'package:flutter/material.dart';
import 'package:imat_app/widgets/scalable_text.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class CartReviewStep extends StatelessWidget {
  const CartReviewStep({super.key});

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final items = iMat.getShoppingCart().items;

    if (items.isEmpty) {
      return const ScalableText("Kundvagnen är tom.");
    }

    final total = iMat.shoppingCartTotal().toStringAsFixed(2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const ScalableText(
          "Granska din kundvagn:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          constraints: const BoxConstraints(maxHeight: 200),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final product = item.product;
              final quantity = item.amount.toInt();
              final price = (item.amount * product.price).toStringAsFixed(2);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    // Product image
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(4),
                        image: DecorationImage(
                          image: iMat.getImage(product).image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Product info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          ScalableText(
                            "$quantity st • ${product.price.toStringAsFixed(2)} kr/st",
                          ),
                        ],
                      ),
                    ),
                    // Price and remove button
                    Column(
                      children: [
                        ScalableText(
                          "$price kr",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            size: 18,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => iMat.shoppingCartRemove(item),
                          tooltip: "Ta bort",
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        ScalableText(
          "Totalt: $total kr",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
