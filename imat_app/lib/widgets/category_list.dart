import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat/util/product_categories.dart';
import 'package:imat_app/widgets/scalable_text.dart';

class CategoryList extends StatelessWidget {
  final void Function(ProductCategory) onCategorySelected;
  final ProductCategory? selected;

  const CategoryList({
    super.key,
    required this.onCategorySelected,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ListView.builder(
        itemCount: ProductCategory.values.length,
        itemBuilder: (context, index) {
          final category = ProductCategory.values[index];
          final categoryName = getCategoryName(category);
          final isSelected = category == selected;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    isSelected ? Colors.teal : Colors.teal.shade100,
                foregroundColor: isSelected ? Colors.white : Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                onCategorySelected(category);
              },
              child: ScalableText(categoryName),
            ),
          );
        },
      ),
    );
  }
}
