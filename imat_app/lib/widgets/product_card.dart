import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/add_to_cart_button.dart';
import 'package:imat_app/widgets/scalable_text.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final ImatDataHandler iMat;
  final VoidCallback? onTap;
  final bool compact;

  const ProductCard(
    this.product,
    this.iMat, {
    super.key,
    this.onTap,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final isFavorite = iMat.isFavorite(product);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: compact ? null : 280, // ✅ Allow null width for compact mode
        height: compact ? 180 : 300,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.teal, width: 3),
              ),
              child: Padding(
                padding: EdgeInsets.all(compact ? 8 : AppTheme.paddingSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10), // 🔥 Shift image a bit lower
                    SizedBox(
                      height:
                          compact
                              ? 80
                              : 140, // 🔥 Increased image height in horizontal
                      width:
                          compact
                              ? 150
                              : 220, // 🔥 Increased image width in horizontal
                      child: iMat.getImage(product),
                    ),
                    const SizedBox(
                      height: 12,
                    ), // 🔥 Slightly larger gap under image
                    ScalableText(
                      product.name,
                      style: TextStyle(
                        fontSize: compact ? 14 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    ScalableText(
                      '${product.price.toStringAsFixed(2)} ${product.unit}',
                      style: TextStyle(fontSize: compact ? 12 : 14),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(), // 🔥 Pushes the button to the bottom
                    const SizedBox(height: 5), // 🔥 5px spacing above button
                    SizedBox(
                      height: compact ? 40 : 50,
                      width: double.infinity,
                      child: AddToCartButton(product: product),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -5,
              right: -1,
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
