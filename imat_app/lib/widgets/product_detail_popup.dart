import 'package:flutter/material.dart';
import 'package:imat_app/widgets/add_to_cart_button.dart';
import 'package:imat_app/widgets/close-button.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/scalable_text.dart';
import 'package:imat_app/providers/text_size_provider.dart';

class ProductDetailDialog extends StatelessWidget {
  final Product product;
  final ScrollController _scrollController = ScrollController();

  ProductDetailDialog({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final detail = iMat.getDetail(product);
    final isFavorite = iMat.isFavorite(product);
    
    // Get the text scale factor to adjust width
    final textScale = Provider.of<TextSizeProvider>(context).textScale;
    
    // Calculate width with scaling based on text size
    final baseWidth = 480.0;
    final dialogWidth = baseWidth * (1.0 + ((textScale - 1.0) * 0.5));

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(24),
      child: SizedBox(
        width: dialogWidth,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Main content in scrollable area
            Flexible(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Theme(
                      // Apply scrollbar theme with gray color
                      data: Theme.of(context).copyWith(
                        scrollbarTheme: ScrollbarThemeData(
                          thumbVisibility: MaterialStateProperty.all(true),
                          thumbColor: MaterialStateProperty.all(
                            Colors.grey.withOpacity(0.6),
                          ),
                          radius: const Radius.circular(8),
                          thickness: MaterialStateProperty.all(6),
                          mainAxisMargin: 2,
                          crossAxisMargin: 2,
                        ),
                      ),
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        trackVisibility: false,
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: SizedBox(height: 200, child: iMat.getImage(product)),
                              ),
                              const SizedBox(height: 16),
                              ScalableText(
                                product.name,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              ScalableText(
                                '${product.price.toStringAsFixed(2)} ${product.unit}',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(height: 16),

                              if (detail != null) ...[
                                _detailRow("Märke", detail.brand),
                                _detailRow("Innehåll", detail.contents),
                                _detailRow("Ursprung", detail.origin),
                                const SizedBox(height: 16),
                                ScalableText(
                                  detail.description,
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ] else
                                ScalableText(
                                  "Ingen beskrivning tillgänglig.",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              
                              // Add padding at bottom to ensure content doesn't get hidden behind button panel
                              const SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),

                  // Favorite button - remains outside of scrollable area
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: Colors.redAccent,
                          size: 32,
                        ),
                        onPressed: () {
                          iMat.toggleFavorite(product);
                        },
                        padding: const EdgeInsets.all(8),
                        constraints: const BoxConstraints(),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Divider to separate the content area from buttons
            const Divider(height: 1, thickness: 1, color: Colors.black12),

            // Fixed button row at bottom
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CloseButtonWidget(),
                  AddToCartButton(product: product),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ScalableText(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: ScalableText(
              value.isNotEmpty ? value : "-",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
