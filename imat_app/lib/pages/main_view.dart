import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat/sort_mode.dart';
import 'package:imat_app/model/imat/util/product_categories.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/category_sidebar';
import 'package:imat_app/widgets/expandable_help_overlay.dart';
import 'package:imat_app/widgets/filtered_product_selection.dart';
import 'package:imat_app/widgets/sorting_dropdown.dart';
import 'package:imat_app/widgets/top_bar.dart';
import 'package:provider/provider.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  ProductCategory? selectedCategory;
  SortMode sortMode = SortMode.alphabetical; // 🔥 New state for sorting

  @override
  Widget build(BuildContext context) {
    var iMat = context.watch<ImatDataHandler>();
    final allProducts = CategoryUtils.buildCategorizedProducts(iMat);

    final filteredProducts =
        selectedCategory != null
            ? {
              CategoryUtils.getCategoryName(selectedCategory!):
                  iMat.selectProducts
                      .where((p) => p.category == selectedCategory)
                      .toList(),
            }
            : allProducts;

    return Scaffold(
      appBar: TopBar(
        onSearchStarted: () {
          setState(() {
            selectedCategory = null;
          });
        },
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CategorySidebar(
                  selectedCategory: selectedCategory,
                  onSelect: (category) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SortingDropdown(
                          currentSort: sortMode,
                          onSortChanged: (mode) {
                            setState(() {
                              sortMode = mode;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: FilteredProductSection(
                          selectedCategory: selectedCategory,
                          onClearFilter: () {
                            setState(() {
                              selectedCategory = null;
                            });
                          },
                          categorizedProducts: filteredProducts,
                          iMat: iMat,
                          sortMode: sortMode, // 🔥 Pass it down
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const ExpandableHelpOverlay(),
        ],
      ),
    );
  }
}
