import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat/util/product_categories.dart';
import 'package:imat_app/widgets/scalable_text.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/providers/text_size_provider.dart';

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
  final double borderRadius = 12.0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Get the current text scale factor
    final textScale = Provider.of<TextSizeProvider>(context).textScale;

    // Use the width passed from MainView
    // Make sure we're not subtracting too much from the base width
    // The container itself adds margins of 16 total (8+8)
    final effectiveWidth = widget.width - 16;

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
        color: AppTheme.colorScheme.primary,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.colorScheme.primary, width: 4),
      ),
      child: SizedBox(
        width: effectiveWidth, // Use the adjusted width
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
                    radius: Radius.circular(borderRadius),
                    thickness: MaterialStateProperty.all(6),
                    mainAxisMargin: 2,
                    crossAxisMargin: 8,
                  ),
                ),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(borderRadius),
                      child: Scrollbar(
                        controller: _scrollController,
                        thumbVisibility: true,
                        trackVisibility: false,
                        child: ListView.separated(
                          controller: _scrollController,
                          padding: const EdgeInsets.only(
                            left: 4,
                            right: 16,
                            top: 4,
                            bottom: 4,
                          ),
                          itemCount: sortedCategories.length,
                          separatorBuilder:
                              (context, index) => const SizedBox(height: 8),
                          itemBuilder: (context, index) {
                            final category = sortedCategories[index];
                            final categoryName = CategoryUtils.getCategoryName(
                              category,
                            );
                            final isSelected = category == widget.selected;

                            final BorderRadius itemBorderRadius =
                                BorderRadius.circular(borderRadius);

                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 4.0,
                              ),
                              child: Material(
                                color:
                                    isSelected
                                        ? Colors.teal
                                        : AppTheme.colorScheme.onPrimary,
                                borderRadius: itemBorderRadius,
                                elevation: 0,
                                child: InkWell(
                                  splashColor: Colors.teal.withOpacity(0.3),
                                  highlightColor: Colors.teal.withOpacity(0.1),
                                  hoverColor: Colors.teal.withOpacity(0.04),
                                  borderRadius: itemBorderRadius,
                                  onTap:
                                      () => widget.onCategorySelected(category),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        color: Colors.teal,
                                        width: isSelected ? 2.5 : 2,
                                      ),
                                      borderRadius: itemBorderRadius,
                                    ),
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
                                            fontSize: 18,
                                            color:
                                                isSelected
                                                    ? Colors.white
                                                    : AppTheme
                                                        .colorScheme
                                                        .onSurface,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          // Add this to prevent awkward text wrapping
                                          softWrap: true,
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 2,
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
