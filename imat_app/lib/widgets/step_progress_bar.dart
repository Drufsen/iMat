import 'package:flutter/material.dart';

class StepProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index % 2 == 0) {
          final stepIndex = index ~/ 2;
          final isActive = stepIndex <= currentStep;
          return Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Colors.teal : Colors.white,
              border: Border.all(color: Colors.teal, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              '${stepIndex + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          return Expanded(child: Container(height: 2, color: Colors.teal));
        }
      }),
    );
  }
}
