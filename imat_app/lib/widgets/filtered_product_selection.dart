import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat/sort_mode.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/product_grid.dart';
import 'package:imat_app/widgets/scalable_text.dart';
import 'package:imat_app/widgets/sorting_dropdown.dart';

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
  SortMode _sortMode = SortMode.alphabetical;

  bool get isFilteredView =>
      widget.selectedCategory != null || widget.iMat.isSearching;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (isFilteredView)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ElevatedButton.icon(
                onPressed: widget.onClearFilter,
                icon: const Icon(Icons.arrow_back),
                label: const ScalableText("Tillbaka"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.brand,
                  foregroundColor: AppTheme.colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 8),
              SortingDropdown(
                currentSort: _sortMode,
                onSortChanged: (mode) {
                  setState(() {
                    _sortMode = mode;
                  });
                },
              ),
            ],
          ),
        Expanded(
          child: ProductGrid(
            categorizedProducts: widget.categorizedProducts,
            iMat: widget.iMat,
            selectedCategory: widget.selectedCategory,
            isFilteredView: isFilteredView,
            sortMode: widget.sortMode, // Pass it down
          ),
        ),
      ],
    );
  }
}
