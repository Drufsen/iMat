import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/scalable_text.dart';

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
              color: isActive ? AppTheme.brand : Colors.white,
              border: Border.all(color: AppTheme.border, width: 2),
            ),
            alignment: Alignment.center,
            child: ScalableText(
              '${stepIndex + 1}',
              style: TextStyle(
                color: isActive ? AppTheme.colorScheme.onPrimary : AppTheme.brand,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          return Expanded(child: Container(height: 2, color: AppTheme.brand));
        }
      }),
    );
  }
}
