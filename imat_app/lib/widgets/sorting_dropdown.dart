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
      children: [
        const ScalableText("Sortera efter: "),
        const SizedBox(width: 8),
        DropdownButton<SortMode>(
          value: currentSort,
          items: const [
            DropdownMenuItem(
              value: SortMode.none,
              child: ScalableText("Ingen"),
            ),
            DropdownMenuItem(
              value: SortMode.byPrice,
              child: ScalableText("Pris"),
            ),
            DropdownMenuItem(
              value: SortMode.alphabetical,
              child: ScalableText("Namn"),
            ),
          ],
          onChanged: (mode) {
            if (mode != null) {
              onSortChanged(mode);
            }
          },
        ),
      ],
    );
  }
}
