import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';

/// A custom floating action button that will expand to show a chat window.
class FloatingHelpButton extends StatefulWidget {
  /// Creates a floating help button.
  ///
  /// The [onToggle] callback is called when the button is pressed.
  const FloatingHelpButton({super.key, this.onToggle});

  /// Called when the button is toggled.
  final Function(bool isExpanded)? onToggle;

  @override
  State<FloatingHelpButton> createState() => _FloatingHelpButtonState();
}

class _FloatingHelpButtonState extends State<FloatingHelpButton> {
  bool _isExpanded = false;

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });

    // Notify parent widget about the state change
    widget.onToggle?.call(_isExpanded);
  }

  @override
  Widget build(BuildContext context) {
    // Position the FAB in the bottom-right corner
    return FloatingActionButton(
      onPressed: _toggleExpansion,
      backgroundColor: AppTheme.colorScheme.primary,
      shape: const CircleBorder(),
      tooltip: 'Hjälp',
      child: Icon(
        size: 50,
        _isExpanded ? Icons.close : Icons.help_sharp,
        color: AppTheme.colorScheme.onPrimary,
      ),
    );
  }
}
