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
import 'package:imat_app/widgets/hover_button.dart';

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
    
    // Use a more moderate scaling factor to avoid excessive spaces - same as in ProductCard
    final scaleFactor = 1.0 + ((textScale - 1.0) * 0.7);

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

      // Calculate the same height as used in non-filtered view
      final cardHeight = 300 * scaleFactor;

      // Use a wrap layout with height-constrained items
      return Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Wrap(
            spacing: 16,
            runSpacing: 16,
            children: products.map((product) {
              return SizedBox(
                width: 250, // Match exactly the width in non-filtered view
                height: cardHeight, // Add height constraint to match non-filtered view
                child: ProductCard(
                  product,
                  iMat,
                  onTap: () {
                    showDialog(
                      context: context,
                      barrierColor: Colors.black.withOpacity(0.5),
                      builder: (context) => ProductDetailDialog(product: product),
                    );
                  },
                ),
              );
            }).toList(),
          ),
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
            // Adjust the height based on the adjusted scale factor
            SizedBox(
              height: 300 * (1.0 + ((textScale - 1.0) * 0.7)),
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

                  // Left arrow - only show when not at the beginning
                  StreamBuilder<double>(
                    stream: Stream.periodic(const Duration(milliseconds: 100), (
                      _,
                    ) {
                      return scrollController.hasClients
                          ? scrollController.offset
                          : 0;
                    }),
                    builder: (context, snapshot) {
                      final showLeftArrow =
                          snapshot.hasData && snapshot.data! > 0;

                      return Positioned(
                        left: 0,
                        top: 0,
                        bottom: 0,
                        child: Visibility(
                          visible: showLeftArrow,
                          maintainState: true,
                          maintainAnimation: true,
                          maintainSize: true,
                          child: Center(
                            child: Material(
                              elevation: 3,
                              color: Colors.grey[200], // Light gray color
                              shape: CircleBorder(
                                side: BorderSide(
                                  color:
                                      Colors
                                          .teal, // Match your app's teal theme
                                  width: 2.0, // Moderately thick border
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  const scrollAmount = 250.0 * 4;
                                  scrollController.animateTo(
                                    scrollController.offset - scrollAmount,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeOut,
                                  );
                                },
                                customBorder: const CircleBorder(),
                                child: Container(
                                  width: 48, // Increased from 40
                                  height: 48, // Increased from 40
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.arrow_back_ios,
                                    size: 24, // Increased from 20
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  // Right arrow - only show when not at the end
                  StreamBuilder<double>(
                    stream: Stream.periodic(const Duration(milliseconds: 100), (
                      _,
                    ) {
                      if (!scrollController.hasClients) return 0.0;
                      return scrollController.position.maxScrollExtent -
                          scrollController.offset;
                    }),
                    builder: (context, snapshot) {
                      final showRightArrow =
                          snapshot.hasData &&
                          snapshot.data! > 5; // Small threshold

                      return Positioned(
                        right: 0,
                        top: 0,
                        bottom: 0,
                        child: Visibility(
                          visible: showRightArrow,
                          maintainState: true,
                          maintainAnimation: true,
                          maintainSize: true,
                          child: Center(
                            child: Material(
                              elevation: 3,
                              color: Colors.grey[200], // Light gray color
                              shape: CircleBorder(
                                side: BorderSide(
                                  color:
                                      Colors
                                          .teal, // Match your app's teal theme
                                  width: 2.0, // Moderately thick border
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  const scrollAmount = 250.0 * 4;
                                  scrollController.animateTo(
                                    scrollController.offset + scrollAmount,
                                    duration: const Duration(milliseconds: 400),
                                    curve: Curves.easeOut,
                                  );
                                },
                                customBorder: const CircleBorder(),
                                child: Container(
                                  width: 48, // Increased from 40
                                  height: 48, // Increased from 40
                                  alignment: Alignment.center,
                                  child: Icon(
                                    Icons.arrow_forward_ios,
                                    size: 24, // Increased from 20
                                    color: Colors.grey[700],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
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
