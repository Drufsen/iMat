import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:imat_app/widgets/expandable_help_overlay.dart';
import 'package:imat_app/widgets/product_grid.dart';
import 'package:imat_app/widgets/top_bar.dart';
import 'package:provider/provider.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    var iMat = context.watch<ImatDataHandler>();
    var products = iMat.selectProducts;

    Map<String, List<Product>> categorizedProducts =
        new Map<String, List<Product>>();
    if (iMat.orders.isNotEmpty) {
      categorizedProducts["Orders"] =
          iMat.orders.first.items.map((item) => item.product).toList();
      categorizedProducts["Wares"] = products;
    }
    for (var category in ProductCategory.values) {
      final productsInCategory =
          iMat.selectProducts
              .where((product) => product.category == category)
              .toList();

      if (productsInCategory.isNotEmpty) {
        categorizedProducts[category.toString()] = productsInCategory;
      }
    }

    return Scaffold(
      appBar: TopBar(),
      body: Stack(
        children: [
          // Main content - Product grid
          Padding(
            padding: const EdgeInsets.all(AppTheme.paddingSmall),
            child: ProductGrid(
              categorizedProducts: categorizedProducts,
              iMat: iMat,
            ),
          ),

          // Help overlay that includes both button and expandable window
          const ExpandableHelpOverlay(),
        ],
      ),
    );
  }
}
