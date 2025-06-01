// lib/widgets/rensa_button.dart

import 'package:flutter/material.dart';
import 'package:imat_app/widgets/scalable_text.dart';

class RensaButton extends StatelessWidget {
  final VoidCallback onPressed;

  const RensaButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final button = ElevatedButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.delete),
      label: const ScalableText("Rensa", style: TextStyle(fontSize: 16)),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );

    return button;
  }
}
