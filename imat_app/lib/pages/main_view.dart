import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/util/product_categories.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/expandable_help_overlay.dart';
import 'package:imat_app/widgets/product_grid.dart';
import 'package:imat_app/widgets/top_bar.dart';
import 'package:provider/provider.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    var iMat = context.watch<ImatDataHandler>();
    final categorizedProducts = buildCategorizedProducts(iMat);

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
