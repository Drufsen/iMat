import 'package:flutter/material.dart';

// Define our text size options
enum TextSize { normal, storre, storst }

class TextSizeProvider extends ChangeNotifier {
  // Default to normal
  TextSize _currentSize = TextSize.normal;
  
  // Map enum to actual scaling factors
  final Map<TextSize, double> _sizeFactors = {
    TextSize.normal: 1.0,    // Normal size (default)
    TextSize.storre: 1.2,    // 20% bigger
    TextSize.storst: 1.4,    // 40% bigger
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