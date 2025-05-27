import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat/util/product_categories.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/category_sidebar';
import 'package:imat_app/widgets/expandable_help_overlay.dart';
import 'package:imat_app/widgets/filtered_product_selection.dart';
import 'package:imat_app/widgets/top_bar.dart';
import 'package:provider/provider.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  ProductCategory? selectedCategory;

  @override
  Widget build(BuildContext context) {
    var iMat = context.watch<ImatDataHandler>();
    final allProducts = buildCategorizedProducts(iMat);

    final filteredProducts =
        selectedCategory != null
            ? {
              getCategoryName(selectedCategory!):
                  iMat.selectProducts
                      .where((p) => p.category == selectedCategory)
                      .toList(),
            }
            : allProducts;

    return Scaffold(
      appBar: TopBar(),
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
                const SizedBox(width: 25),
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
