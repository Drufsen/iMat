import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/cart_button.dart';
import 'package:imat_app/widgets/scalable_text.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  final ImatDataHandler iMat;
  final VoidCallback? onTap; // ✅ Add this line

  const ProductCard(
    this.product,
    this.iMat, {
    super.key,
    this.onTap,
  }); // ✅ Update constructor

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap, // ✅ Add this
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingSmall),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  SizedBox(height: 100, child: iMat.getImage(product)),
                  if (iMat.getQuantityInCart(product) > 0)
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.redAccent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          iMat.getQuantityInCart(product).toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                ],
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
              Center(child: AddToCartButton(product: product)),
            ],
          ),
        ),
      ),
    );
  }
}
