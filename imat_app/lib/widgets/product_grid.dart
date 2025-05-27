import 'package:flutter/material.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/product_detail_popup.dart';
import 'package:imat_app/widgets/scalable_text.dart';

class ProductGrid extends StatelessWidget {
  final Map<String, List<Product>> categorizedProducts;
  final ImatDataHandler iMat;

  const ProductGrid({
    super.key,
    required this.categorizedProducts,
    required this.iMat,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.paddingSmall),
      itemCount: categorizedProducts.length,
      itemBuilder: (context, index) {
        final category = categorizedProducts.keys.elementAt(index);
        final products = categorizedProducts[category]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: Colors.teal,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: ScalableText(
                      category,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 280, // Adjust height to fit ProductCards nicely
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                separatorBuilder:
                    (_, __) => const SizedBox(width: AppTheme.paddingSmall),
                itemBuilder: (context, idx) {
                  final product = products[idx];
                  return SizedBox(
                    width: 250,
                    child: ProductCard(
                      product,
                      iMat,
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierColor: Colors.black.withOpacity(0.5),

                          builder:
                              (context) =>
                                  ProductDetailDialog(product: product),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppTheme.paddingLarge),
          ],
        );
      },
    );
  }
}
