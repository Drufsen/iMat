import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/close-button.dart';
import 'package:imat_app/widgets/scalable_text.dart';

class EmptyCartMessage extends StatelessWidget {
  final VoidCallback? onClose;

  const EmptyCartMessage({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 320),
        decoration: BoxDecoration(
          color: AppTheme.colorScheme.onPrimary,
          border: Border.all(color: AppTheme.border, width: 5),
          borderRadius: BorderRadius.circular(16),
        ),
        clipBehavior: Clip.antiAlias,
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ScalableText('Din kundvagn är tom.', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: CloseButtonWidget(
                onPressed: onClose ?? () => Navigator.of(context).maybePop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
