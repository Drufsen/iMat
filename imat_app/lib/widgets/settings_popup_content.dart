import 'package:flutter/material.dart';
import 'package:imat_app/widgets/close-button.dart';
import 'package:imat_app/widgets/text_size_slider.dart';

class SettingsPopupContent extends StatelessWidget {
  final VoidCallback? onClose;

  const SettingsPopupContent({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        constraints: const BoxConstraints(maxHeight: 420, maxWidth: 320),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.teal, width: 5),
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.only(bottom: 12),
                child: const Row(
                  children: [
                    Icon(Icons.settings, color: Colors.teal),
                    SizedBox(width: 8),
                    Text(
                      'Inställningar',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(thickness: 1.5),

              // Text Size Adjustment
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Textstorlek:',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              const TextSizeSlider(),

              const SizedBox(height: 16),

              // Close button at the bottom
              Align(
                alignment: Alignment.centerLeft,
                child: CloseButtonWidget(onPressed: onClose),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
