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
    return Container(
      width: 70,
      height: 70,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5), // Darker shadow
            spreadRadius: 2, // Larger spread
            blurRadius: 10, // More blur
            offset: const Offset(0, 4), // More distance
          ),
        ],
      ),
      child: FloatingActionButton(
        onPressed: _toggleExpansion,
        backgroundColor: Colors.teal,
        shape: const CircleBorder(),
        tooltip: 'Hjälp',
        elevation: 0, // Remove built-in shadow since we have custom shadow
        highlightElevation: 0,
        child: Icon(
          _isExpanded ? Icons.close : Icons.help_sharp,
          size: 60,
          color: AppTheme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}
