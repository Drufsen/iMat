import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/add_to_cart_button.dart';
import 'package:imat_app/widgets/scalable_text.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/providers/text_size_provider.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final ImatDataHandler iMat;
  final VoidCallback? onTap;

  const ProductCard(this.product, this.iMat, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isFavorite = iMat.isFavorite(product);
    final textScale = Provider.of<TextSizeProvider>(context).textScale;

    // Use a more moderate scaling factor to avoid excessive spaces
    final scaleFactor = 1.0 + ((textScale - 1.0) * 0.7);

    // Fixed height for card with adjusted scaling
    final cardHeight = 300 * scaleFactor;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 280,
        height: cardHeight, // Using adjusted scale factor
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.teal, width: 3),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top content in its own column
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 10),
                      // Keep the image size fixed
                      SizedBox(
                        height: 140,
                        width: 150,
                        child: iMat.getImage(product),
                      ),
                      // Reduce this spacing a bit
                      SizedBox(height: 12 * (textScale < 1.3 ? 1.0 : 0.8)),

                      // Product name
                      ScalableText(
                        product.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      // Reduce this spacing a bit
                      SizedBox(height: 4 * (textScale < 1.3 ? 1.0 : 0.8)),

                      // Price
                      ScalableText(
                        '${product.price.toStringAsFixed(2)} ${product.unit}',
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  // Button at the bottom - using the adjusted scale factor
                  SizedBox(
                    height:
                        47 *
                        scaleFactor, // Scale button height with adjusted factor
                    width: double.infinity,
                    child: AddToCartButton(product: product),
                  ),
                ],
              ),
            ),

            // Favorite button
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
    );
  }
}
