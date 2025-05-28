import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/product_grid.dart';
import 'package:imat_app/widgets/scalable_text.dart';

class FilteredProductSection extends StatelessWidget {
  final ProductCategory? selectedCategory;
  final void Function() onClearFilter;
  final Map<String, List<Product>> categorizedProducts;
  final ImatDataHandler iMat;

  const FilteredProductSection({
    super.key,
    required this.selectedCategory,
    required this.onClearFilter,
    required this.categorizedProducts,
    required this.iMat,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (selectedCategory != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ElevatedButton.icon(
                onPressed: onClearFilter,
                icon: const Icon(Icons.arrow_back),
                label: const ScalableText("Tillbaka"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.brand,
                  foregroundColor: AppTheme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        Expanded(
          child: ProductGrid(
            categorizedProducts: categorizedProducts,
            iMat: iMat,
            selectedCategory: selectedCategory, // ✅ Pass this down!
          ),
        ),
      ],
    );
  }
}
