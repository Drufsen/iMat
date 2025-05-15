import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/product_card.dart';
import 'package:imat_app/widgets/help_button.dart';
import 'package:imat_app/widgets/help_window.dart'; // Import ChatWindow
import 'package:provider/provider.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});
  
  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> with SingleTickerProviderStateMixin {
  bool _isHelpExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void _handleHelpToggle(bool isExpanded) {
    setState(() {
      _isHelpExpanded = isExpanded;
    });
    
    if (_isHelpExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    var iMat = context.watch<ImatDataHandler>();
    var products = iMat.selectProducts;
    final screenSize = MediaQuery.of(context).size;
    
    return Scaffold(
      appBar: AppBar(title: const Text('iMats produkter')),
      body: Stack(
        children: [
          // Main content
          Padding(
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
          
          // Chat window overlay
          Positioned(
            right: 16,
            bottom: 80, // Position above the FAB
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return Container(
                  width: 300,
                  height: _animation.value * 400, // Animate the height
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _animation.value > 0.1 ? const HelpWindow() : const SizedBox(),
                );
              },
            ),
          ),
        ],
      ),
      // Add the floating action button here
      floatingActionButton: FloatingHelpButton(
        onToggle: _handleHelpToggle,
      ),
    );
  }
}
