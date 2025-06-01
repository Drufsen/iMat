import 'package:flutter/material.dart';

class HoverButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final Color? backgroundColor;
  final double size;

  const HoverButton({
    Key? key,
    required this.child,
    required this.onTap,
    this.backgroundColor,
    this.size = 40,
  }) : super(key: key);

  @override
  State<HoverButton> createState() => _HoverButtonState();
}

class _HoverButtonState extends State<HoverButton> {
  bool isHovering = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovering = true),
      onExit: (_) => setState(() => isHovering = false),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: widget.onTap,
        onTapDown: (_) => setState(() => isPressed = true),
        onTapUp: (_) => setState(() => isPressed = false),
        onTapCancel: () => setState(() => isPressed = false),
        child: AnimatedScale(
          scale: isPressed ? 0.95 : 1.0,
          duration: const Duration(milliseconds: 150),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 8),
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              color:
                  widget.backgroundColor ??
                  Theme.of(context).colorScheme.onSecondary,
              shape: BoxShape.circle,
              boxShadow:
                  isHovering
                      ? [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ]
                      : null,
            ),
            child: Center(child: widget.child),
          ),
        ),
      ),
    );
  }
}
