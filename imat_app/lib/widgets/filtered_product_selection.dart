import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat/sort_mode.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/product_grid.dart';
import 'package:imat_app/widgets/scalable_text.dart';

class FilteredProductSection extends StatefulWidget {
  final ProductCategory? selectedCategory;
  final void Function() onClearFilter;
  final Map<String, List<Product>> categorizedProducts;
  final ImatDataHandler iMat;
  final SortMode sortMode; // 🔥 Add this parameter

  const FilteredProductSection({
    super.key,
    required this.selectedCategory,
    required this.onClearFilter,
    required this.categorizedProducts,
    required this.iMat,
    required this.sortMode,
  });

  @override
  State<FilteredProductSection> createState() => _FilteredProductSectionState();
}

class _FilteredProductSectionState extends State<FilteredProductSection> {
  bool get isFilteredView =>
      widget.selectedCategory != null || widget.iMat.isSearching;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isFilteredView)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.paddingMedium,
              vertical: AppTheme.paddingSmall,
            ),
            child: Row(
              children: [
                ElevatedButton.icon(
                  onPressed: widget.onClearFilter,
                  icon: Icon(Icons.arrow_back),
                  label: ScalableText("Tillbaka", style: TextStyle(fontSize: 16)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brand,
                    foregroundColor: AppTheme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        Expanded(
          child: ProductGrid(
            categorizedProducts: widget.categorizedProducts,
            iMat: widget.iMat,
            selectedCategory: widget.selectedCategory,
            isFilteredView: isFilteredView,
            sortMode: widget.sortMode,
          ),
        ),
      ],
    );
  }
}
