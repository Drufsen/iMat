import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:imat_app/widgets/help_button.dart'; // Import the FloatingChatButton
import 'package:provider/provider.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  
  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  bool _isChatExpanded = false;
  
  void _handleHelpToggle(bool isExpanded) {
    setState(() {
      _isChatExpanded = isExpanded;
    });
    // Later, you'll handle the chat expansion logic here
  }

  @override
  Widget build(BuildContext context) {
    var iMat = context.watch<ImatDataHandler>();
    var products = iMat.selectProducts;
    // Det finns en version utan gridDelegate nedan.
    // Den kan vara enklare att förstå.
    // Denna version har fördelen att kort skapas on-demand.
    return Scaffold(
      appBar: AppBar(title: const Text('iMats produkter')),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.paddingSmall),
        child: GridView.builder(
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
        ),
      ),
      // Add the floating action button here
      floatingActionButton: HelpButton(
        onToggle: _handleHelpToggle,
      ),
    );
  }
}