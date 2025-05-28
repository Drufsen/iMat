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

  const ProductCard(this.product, this.iMat, {super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    final isFavorite = iMat.isFavorite(product);
    final quantity = iMat.getQuantityInCart(product);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
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
              padding: const EdgeInsets.all(AppTheme.paddingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 120,
                    width: 200,
                    child: iMat.getImage(product),
                  ),
                  const SizedBox(height: 8),
                  ScalableText(
                    product.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  ScalableText(
                    '${product.price.toStringAsFixed(2)} ${product.unit}',
                    style: const TextStyle(fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppTheme.paddingLarge),
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: double.infinity,
                      child: AddToCartButton(product: product),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // ❤️ Favorite button in top-right corner
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
    );
  }
}
