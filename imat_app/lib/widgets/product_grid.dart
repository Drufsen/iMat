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

  static const double productWidth = 250;
  static const int itemsPerPage = 4;
  static const double scrollAmount = productWidth * itemsPerPage;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.paddingSmall),
      itemCount: categorizedProducts.length,
      itemBuilder: (context, index) {
        final category = categorizedProducts.keys.elementAt(index);
        final products = categorizedProducts[category]!;
        final scrollController = ScrollController();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              category,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            SizedBox(
              height: 300,
              child: Stack(
                children: [
                  // Själva produktlistan
                  ListView.separated(
                    controller: scrollController,
                    scrollDirection: Axis.horizontal,
                    itemCount: products.length,
                    padding: const EdgeInsets.symmetric(horizontal: 40),
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

                  // Vänsterpil
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        scrollController.animateTo(
                          scrollController.offset - scrollAmount,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          Icons.arrow_back_ios,
                          size: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),

                  // Högerpil
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        scrollController.animateTo(
                          scrollController.offset + scrollAmount,
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOut,
                        );
                      },
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          Icons.arrow_forward_ios,
                          size: 20,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.paddingLarge),
          ],
        );
      },
    );
  }
}
