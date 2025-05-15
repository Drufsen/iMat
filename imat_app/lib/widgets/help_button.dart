import 'package:flutter/material.dart';

/// A custom floating action button that will expand to show a chat window.
class HelpButton extends StatefulWidget {
  /// Creates a floating help button.
  ///
  /// The [onToggle] callback is called when the button is pressed.
  const HelpButton({
    Key? key,
    this.onToggle,
  }) : super(key: key);

  /// Called when the button is toggled.
  final Function(bool isExpanded)? onToggle;

  @override
  State<HelpButton> createState() => _HelpButtonState();
}

class _HelpButtonState extends State<HelpButton> {
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
      backgroundColor: const Color.fromARGB(255, 0, 169, 211),
      shape: const CircleBorder(),
      child: Icon(
        size: 50,
        _isExpanded ? Icons.close : Icons.help_sharp,
        color: Colors.white,
      ),
      tooltip: 'Hjälp',
    );
  }
}