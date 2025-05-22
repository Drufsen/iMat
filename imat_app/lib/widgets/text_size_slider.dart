import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/providers/text_size_provider.dart';
import 'package:imat_app/widgets/scalable_text.dart';

class TextSizeSlider extends StatelessWidget {
  const TextSizeSlider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TextSizeProvider>(
      builder: (context, textSizeProvider, child) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(8.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4.0,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScalableText(
                'Text Size',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              // Sample text that changes size
              ScalableText(
                'This text will change size based on the slider',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              // Slider with labels
              Row(
                children: [
                  ScalableText('Small', style: TextStyle(fontSize: 14)),
                  Expanded(
                    child: Slider(
                      value: textSizeProvider.currentSize.index.toDouble(),
                      min: 0,
                      max: 2,
                      divisions: 2,
                      onChanged: (value) {
                        textSizeProvider.setTextSize(
                          TextSize.values[value.toInt()],
                        );
                      },
                    ),
                  ),
                  ScalableText('Large', style: TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 8),
              // Current size indicator
              ScalableText(
                'Current: ${textSizeProvider.currentSize.toString().split('.').last}',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      },
    );
  }
}
