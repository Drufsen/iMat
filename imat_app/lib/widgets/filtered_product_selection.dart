// New file: widgets/filtered_product_section.dart

import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/product_grid.dart';

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
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: ElevatedButton.icon(
                onPressed: onClearFilter,
                icon: const Icon(Icons.arrow_back),
                label: const Text("Tillbaka"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ),
        Expanded(
          child: ProductGrid(
            categorizedProducts: categorizedProducts,
            iMat: iMat,
          ),
        ),
      ],
    );
  }
}
