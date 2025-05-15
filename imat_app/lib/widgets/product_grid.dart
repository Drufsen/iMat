import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class ProductGrid extends StatelessWidget {
  final List products;
  final ImatDataHandler iMat;

  const ProductGrid({super.key, required this.products, required this.iMat});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppTheme.paddingSmall),
      child: GridView.builder(
        itemCount: products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: AppTheme.paddingSmall,
          mainAxisSpacing: AppTheme.paddingSmall,
          childAspectRatio: 4 / 3,
        ),
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(product, iMat);
        },
      ),
    );
  }
}
