import 'package:flutter/material.dart';

// Define our text size options
enum TextSize { small, medium, large }

class TextSizeProvider extends ChangeNotifier {
  // Default to medium
  TextSize _currentSize = TextSize.medium;
  
  // Map enum to actual scaling factors
  final Map<TextSize, double> _sizeFactors = {
    TextSize.small: 0.8,
    TextSize.medium: 1.0,
    TextSize.large: 1.2,
  };
  
  // Getter for current text size
  TextSize get currentSize => _currentSize;
  
  // Getter for the actual scaling factor
  double get textScale => _sizeFactors[_currentSize] ?? 1.0;
  
  // Method to update text size
  void setTextSize(TextSize size) {
    if (_currentSize != size) {
      _currentSize = size;
      notifyListeners();
    }
  }
}