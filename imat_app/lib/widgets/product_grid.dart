import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/sort_mode.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/product_detail_popup.dart';
import 'package:imat_app/widgets/scalable_text.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/providers/text_size_provider.dart';

class ProductGrid extends StatelessWidget {
  final Map<String, List<Product>> categorizedProducts;
  final ImatDataHandler iMat;
  final ProductCategory? selectedCategory;
  final bool isFilteredView;
  final SortMode sortMode;

  const ProductGrid({
    super.key,
    required this.categorizedProducts,
    required this.iMat,
    required this.selectedCategory,
    required this.isFilteredView,
    required this.sortMode,
  });

  @override
  Widget build(BuildContext context) {
    // Get the text scale factor to adjust heights
    final textScale = Provider.of<TextSizeProvider>(context).textScale;

    if (isFilteredView) {
      // Flatten products into a single list
      List<Product> products =
          categorizedProducts.values.expand((x) => x).toList();

      // Apply sorting
      if (sortMode == SortMode.byPrice) {
        products.sort((a, b) => a.price.compareTo(b.price));
      } else if (sortMode == SortMode.alphabetical) {
        products.sort((a, b) => a.name.compareTo(b.name));
      }

      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          // Remove fixed aspect ratio to allow variable heights
          childAspectRatio: 0.7, // Base aspect ratio
        ),
        itemCount: products.length,
        itemBuilder:
            (context, index) => ProductCard(
              products[index],
              iMat,
              onTap: () {
                showDialog(
                  context: context,
                  barrierColor: Colors.black.withOpacity(0.5),
                  builder:
                      (context) =>
                          ProductDetailDialog(product: products[index]),
                );
              },
            ),
      );
    }

    // Horizontal layout (default)
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.paddingSmall),
      itemCount: categorizedProducts.length,
      itemBuilder: (context, index) {
        final category = categorizedProducts.keys.elementAt(index);
        List<Product> products = List<Product>.from(
          categorizedProducts[category]!,
        );

        // Apply sorting
        if (sortMode == SortMode.byPrice) {
          products.sort((a, b) => a.price.compareTo(b.price));
        } else if (sortMode == SortMode.alphabetical) {
          products.sort((a, b) => a.name.compareTo(b.name));
        }

        final scrollController = ScrollController();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Container(
                    color: AppTheme.colorScheme.primary,
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
            // Adjust the height based on text scale
            SizedBox(
              height:
                  300 *
                  textScale, // Dynamically scale height from a base of 300
              child: Stack(
                children: [
                  // Product list
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
                        // No fixed height here - let it adapt
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

                  // Left arrow
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        const scrollAmount = 250.0 * 4;
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

                  // Right arrow
                  Positioned(
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        const scrollAmount = 250.0 * 4;
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
