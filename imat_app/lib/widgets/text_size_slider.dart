import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/providers/text_size_provider.dart';
import 'package:imat_app/widgets/scalable_text.dart';

class TextSizeSlider extends StatelessWidget {
  const TextSizeSlider({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TextSizeProvider>(
      builder: (context, textSizeProvider, child) {
        final currentIndex = textSizeProvider.currentSize.index;
        final isMinSize = currentIndex == 0; // normal
        final isMaxSize = currentIndex == 2; // storst

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
              Row(
                children: [
                  // Minus button
                  IconButton(
                    iconSize: 32,
                    padding: const EdgeInsets.all(12),
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed:
                        isMinSize
                            ? null
                            : () {
                              final newIndex = currentIndex - 1;
                              if (newIndex >= 0) {
                                textSizeProvider.setTextSize(
                                  TextSize.values[newIndex],
                                );
                              }
                            },
                    color:
                        isMinSize
                            ? Colors.grey.shade400
                            : Colors.teal, // Changed to teal
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: Colors.teal,
                        inactiveTrackColor: Colors.teal.withOpacity(0.3),
                        thumbColor: Colors.teal,
                        overlayColor: Colors.teal.withOpacity(0.2),
                        trackHeight: 4,
                      ),
                      child: Slider(
                        value: currentIndex.toDouble(),
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
                  ),
                  // Plus button
                  IconButton(
                    iconSize: 32,
                    padding: const EdgeInsets.all(12),
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed:
                        isMaxSize
                            ? null
                            : () {
                              final newIndex = currentIndex + 1;
                              if (newIndex <= 2) {
                                textSizeProvider.setTextSize(
                                  TextSize.values[newIndex],
                                );
                              }
                            },
                    color:
                        isMaxSize
                            ? Colors.grey.shade400
                            : Colors.teal, // Changed to teal
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ScalableText(
                'Textstorlek: ${_getSizeLabel(textSizeProvider.currentSize)}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getSizeLabel(TextSize size) {
    switch (size) {
      case TextSize.normal:
        return 'Normal';
      case TextSize.storre:
        return 'Större';
      case TextSize.storst:
        return 'Störst';
    }
  }
}
