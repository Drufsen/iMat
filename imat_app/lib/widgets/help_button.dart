import 'package:flutter/material.dart';

/// A custom floating action button that will expand to show a chat window.
class FloatingChatButton extends StatefulWidget {
  /// Creates a floating chat button.
  ///
  /// The [onToggle] callback is called when the button is pressed.
  const FloatingChatButton({
    Key? key,
    this.onToggle,
  }) : super(key: key);

  /// Called when the button is toggled.
  final Function(bool isExpanded)? onToggle;

  @override
  State<FloatingChatButton> createState() => _FloatingChatButtonState();
}

class _FloatingChatButtonState extends State<FloatingChatButton> {
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
      backgroundColor: Colors.blue,
      child: Icon(
        _isExpanded ? Icons.close : Icons.chat,
        color: Colors.white,
      ),
      tooltip: 'Chat',
    );
  }
}