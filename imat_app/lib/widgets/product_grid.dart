import 'package:flutter/material.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/product_detail_popup.dart';

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
            Text(
              category,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 250, // Adjust height to fit ProductCards nicely
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: products.length,
                separatorBuilder:
                    (_, __) => const SizedBox(width: AppTheme.paddingSmall),
                itemBuilder: (context, idx) {
                  final product = products[idx];
                  return SizedBox(
                    width: 180,
                    child: ProductCard(
                      product,
                      iMat,
                      onTap: () {
                        showDialog(
                          context: context,
                          barrierDismissible:
                              false, // ⛔ Don't allow tap-to-close outside the dialog
                          barrierColor: Colors.black.withOpacity(
                            0.5,
                          ), // ✅ Dimmed background
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
