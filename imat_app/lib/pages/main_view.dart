import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:imat_app/widgets/expandable_help_overlay.dart';
import 'package:provider/provider.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    var iMat = context.watch<ImatDataHandler>();
    var products = iMat.selectProducts;

    return Scaffold(
      appBar: AppBar(title: const Text('iMats produkter')),
      body: Stack(
        children: [
          // Main content - Product grid
          Padding(
            padding: const EdgeInsets.all(AppTheme.paddingSmall),
            child: _buildProductGrid(products, iMat),
          ),

          // Help overlay that includes both button and expandable window
          const ExpandableHelpOverlay(),
        ],
      ),
    );
  }

  /// Builds the product grid view
  Widget _buildProductGrid(List<dynamic> products, ImatDataHandler iMat) {
    return GridView.builder(
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4, // 4 kolumner
        crossAxisSpacing: AppTheme.paddingSmall,
        mainAxisSpacing: AppTheme.paddingSmall,
        childAspectRatio: 4 / 3,
      ),
      itemBuilder: (context, index) {
        final product = products[index];
        return ProductCard(product, iMat);
      },
    );
  }
}
