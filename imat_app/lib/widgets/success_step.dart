import 'package:flutter/material.dart';
import 'package:imat_app/widgets/scalable_text.dart';

class SuccessStep extends StatelessWidget {
  const SuccessStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, size: 120, color: Colors.green),
              const SizedBox(height: 24),
              const ScalableText(
                "Tack för din beställning!",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
