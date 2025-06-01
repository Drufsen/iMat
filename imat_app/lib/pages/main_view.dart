import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat/sort_mode.dart';
import 'package:imat_app/model/imat/util/product_categories.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/category_list.dart';
import 'package:imat_app/widgets/expandable_help_overlay.dart';
import 'package:imat_app/widgets/filtered_product_selection.dart';
import 'package:imat_app/widgets/sorting_dropdown.dart';
import 'package:imat_app/widgets/top_bar.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/providers/text_size_provider.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  ProductCategory? selectedCategory;
  SortMode sortMode = SortMode.alphabetical;

  final TextEditingController searchController = TextEditingController();

  void _handleCategorySelected(ProductCategory category) {
    setState(() {
      selectedCategory = category;
    });
    searchController.clear();
  }

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

    // Get text scale for dynamic sizing
    final textScale = Provider.of<TextSizeProvider>(context).textScale;

    // Increase the base size with an additional constant for more breathing room
    const double baseWidth = 220.0;
    const double extraConstantWidth = 20.0; // Additional constant width
    // Add extra width only when text scale increases
    final double extraScaleWidth =
        textScale > 1.0 ? baseWidth * (textScale - 1.0) * 0.8 : 0.0;
    final double categoryListWidth =
        baseWidth + extraConstantWidth + extraScaleWidth;

    return Scaffold(
      appBar: TopBar(
        onSearchStarted: () {
          setState(() {
            selectedCategory = null;
          });
        },
        searchController: searchController,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category list with original width plus scaling
                SizedBox(
                  width: categoryListWidth,
                  child: CategoryList(
                    onCategorySelected: _handleCategorySelected,
                    selected: selectedCategory,
                    width: categoryListWidth, // DON'T subtract any padding
                  ),
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
                            searchController.clear();
                            iMat.clearSearch();
                          },
                          categorizedProducts: filteredProducts,
                          iMat: iMat,
                          sortMode: sortMode,
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
