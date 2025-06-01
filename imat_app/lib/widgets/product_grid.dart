import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/sort_mode.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/product_detail_popup.dart';
import 'package:imat_app/widgets/scalable_text.dart';

/// Widget som visar produkter antingen i ett rutnät (filtrerat läge)
/// eller horisontellt per kategori (standardläge).
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
    // Om filtrerat läge: visa alla produkter i ett rutnät
    if (isFilteredView) {
      // Platta ut alla produkter till en lista
      List<Product> products =
          categorizedProducts.values.expand((x) => x).toList();

      // Sortera produkterna enligt valt sorteringsläge
      if (sortMode == SortMode.byPrice) {
        products.sort((a, b) => a.price.compareTo(b.price));
      } else if (sortMode == SortMode.alphabetical) {
        products.sort((a, b) => a.name.compareTo(b.name));
      }

      // Bygg rutnätsvyn
      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            product,
            iMat,
            onTap: () {
              // Visa popup med produktdetaljer vid klick
              showDialog(
                context: context,
                barrierColor: Colors.black.withOpacity(0.5),
                builder: (context) => ProductDetailDialog(product: product),
              );
            },
          );
        },
      );
    }

    // Standardläge: visa produkter horisontellt per kategori
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.paddingSmall),
      itemCount: categorizedProducts.length,
      itemBuilder: (context, index) {
        final category = categorizedProducts.keys.elementAt(index);
        List<Product> products = List<Product>.from(
          categorizedProducts[category]!,
        );

        // Sortera produkterna enligt valt sorteringsläge
        if (sortMode == SortMode.byPrice) {
          products.sort((a, b) => a.price.compareTo(b.price));
        } else if (sortMode == SortMode.alphabetical) {
          products.sort((a, b) => a.name.compareTo(b.name));
        }

        // ScrollController för horisontell scrollning
        final scrollController = ScrollController();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kategorirubrik
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
            SizedBox(
              height: 300,
              child: Stack(
                children: [
                  // Horisontell lista med produkter
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
                            // Visa popup med produktdetaljer vid klick
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

                  // Vänsterpil för att scrolla bakåt
                  Positioned(
                    left: 0,
                    top: 0,
                    bottom: 0,
                    child: GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        const scrollAmount = 250.0 * 4; // 4 produkter à 250px
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

                  // Högerpil för att scrolla framåt
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
            // Extra utrymme mellan kategorier
            const SizedBox(height: AppTheme.paddingLarge),
          ],
        );
      },
    );
  }
}
