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
            (category) =>
                CategoryUtils.getCategoryName(category) == "Okänd kategori",
          )
          ..sort(
            (a, b) => CategoryUtils.getCategoryName(
              a,
            ).compareTo(CategoryUtils.getCategoryName(b)),
          );

    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: AppTheme.brand,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border, width: 4),
      ),
      child: SizedBox(
        width: 200,
        child: ListView.builder(
          itemCount: sortedCategories.length,
          itemBuilder: (context, index) {
            final category = sortedCategories[index];
            final categoryName = CategoryUtils.getCategoryName(category);
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
