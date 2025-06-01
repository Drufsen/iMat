import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/sort_mode.dart';
import 'package:imat_app/widgets/scalable_text.dart';

class SortingDropdown extends StatelessWidget {
  final SortMode currentSort;
  final ValueChanged<SortMode> onSortChanged;

  const SortingDropdown({
    super.key,
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start, // Ensure left alignment
      children: [
        const ScalableText(
          "Sortera efter:",
          style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 18, // Increase from default size
          ),
        ),
        const SizedBox(width: 8),
        DropdownButton<SortMode>(
          value: currentSort,
          items: const [
            DropdownMenuItem(
              value: SortMode.alphabetical,
              child: ScalableText("Namn"),
            ),
            DropdownMenuItem(
              value: SortMode.byPrice,
              child: ScalableText("Pris"),
            ),
          ],
          onChanged: (mode) {
            if (mode != null) {
              onSortChanged(mode);
            }
          },
          underline: Container(
            height: 1,
            color: Theme.of(context).colorScheme.primary, // Match the app's color scheme
          ),
        ),
      ],
    );
  }
}
