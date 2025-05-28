import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
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
    final sortedCategories =
        List<ProductCategory>.from(ProductCategory.values)
          ..removeWhere(
            (category) => getCategoryName(category) == "Okänd kategori",
          )
          ..sort((a, b) => getCategoryName(a).compareTo(getCategoryName(b)));

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.brand,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border, width: 4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, bottom: 12.0),
            child: Text(
              "Kategorier",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.colorScheme.onPrimary,
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              width: 200,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: RawScrollbar(
                  thumbColor: Colors.white.withOpacity(0.6),
                  radius: const Radius.circular(10),
                  thickness: 6,
                  thumbVisibility: true,
                  child: ListView.builder(
                    itemCount: sortedCategories.length,
                    padding: const EdgeInsets.only(right: 8), // Add padding on the right for the scrollbar
                    itemBuilder: (context, index) {
                      final category = sortedCategories[index];
                      final categoryName = getCategoryName(category);
                      final isSelected = category == selected;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: isSelected ? AppTheme.brand : AppTheme.colorScheme.onPrimary,
                            border: Border.all(color: AppTheme.border, width: 2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () => onCategorySelected(category),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 8,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: ScalableText(
                                  categoryName,
                                  style: TextStyle(
                                    color: isSelected ? AppTheme.colorScheme.onPrimary : Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
