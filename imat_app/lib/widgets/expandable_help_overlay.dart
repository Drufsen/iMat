import 'package:flutter/material.dart';
import 'package:imat_app/widgets/help_button.dart';
import 'package:imat_app/widgets/help_window.dart';

/// A widget that handles the expandable help feature.
/// This combines the help button and the expandable help window.
class ExpandableHelpOverlay extends StatefulWidget {
  const ExpandableHelpOverlay({Key? key}) : super(key: key);

  @override
  State<ExpandableHelpOverlay> createState() => _ExpandableHelpOverlayState();
}

class _ExpandableHelpOverlayState extends State<ExpandableHelpOverlay>
    with SingleTickerProviderStateMixin {
  bool _isHelpExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleHelpToggle(bool isExpanded) {
    setState(() {
      _isHelpExpanded = isExpanded;
    });

    if (_isHelpExpanded) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Help window overlay
        Positioned(
          right: 16,
          bottom: 80, // Position above the FAB
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return Container(
                width: 300,
                height: _animation.value * 400, // Animate the height
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child:
                    _animation.value > 0.1
                        ? const HelpWindow()
                        : const SizedBox(),
              );
            },
          ),
        ),

        // Floating help button
        Positioned(
          right: 16,
          bottom: 16,
          child: FloatingHelpButton(onToggle: _handleHelpToggle),
        ),
      ],
    );
  }
}
