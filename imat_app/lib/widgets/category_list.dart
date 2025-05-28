import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat/util/product_categories.dart';
import 'package:imat_app/widgets/scalable_text.dart';

class CategoryList extends StatefulWidget {
  final void Function(ProductCategory) onCategorySelected;
  final ProductCategory? selected;
  final double width;

  const CategoryList({
    Key? key,
    required this.onCategorySelected,
    required this.selected,
    this.width = 200,
  }) : super(key: key);

  @override
  State<CategoryList> createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final sortedCategories =
        List<ProductCategory>.from(ProductCategory.values)
          ..removeWhere(
            (category) =>
                CategoryUtils.getCategoryName(category) == "Okänd kategori",
          )
          ..sort(
            (a, b) => CategoryUtils.getCategoryName(a)
                .compareTo(CategoryUtils.getCategoryName(b)),
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
        width: widget.width,
        child: Column(
          children: [
            // Header for the category list
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 12),
              child: ScalableText(
                'Kategorier',
                style: TextStyle(
                  color: AppTheme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            // Divider under the header
            Divider(
              color: AppTheme.colorScheme.onPrimary.withOpacity(0.5),
              thickness: 1.0,
              height: 1.0,
            ),
            const SizedBox(height: 8),
            // List of categories
            Expanded(
              child: Theme(
                data: Theme.of(context).copyWith(
                  scrollbarTheme: ScrollbarThemeData(
                    thumbVisibility: MaterialStateProperty.all(true),
                    thumbColor: MaterialStateProperty.all(
                      AppTheme.colorScheme.onPrimary.withOpacity(0.6),
                    ),
                    radius: const Radius.circular(10),
                    thickness: MaterialStateProperty.all(6),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(right: 4), // Add padding for scrollbar
                  child: Scrollbar(
                    controller: _scrollController,
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.only(right: 8), // Extra padding for list items
                      itemCount: sortedCategories.length,
                      itemBuilder: (context, index) {
                        final category = sortedCategories[index];
                        final categoryName = CategoryUtils.getCategoryName(category);
                        final isSelected = category == widget.selected;

                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 2.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.brand
                                  : AppTheme.colorScheme.onPrimary,
                              border: Border.all(color: AppTheme.border, width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(12),
                              onTap: () => widget.onCategorySelected(category),
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
                                      color: isSelected
                                          ? AppTheme.colorScheme.onPrimary
                                          : AppTheme.colorScheme.onSurface,
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
      ),
    );
  }
}
