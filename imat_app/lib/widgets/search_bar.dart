import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class SearchBarWidget extends StatefulWidget {
  final VoidCallback onSearchStarted;

  const SearchBarWidget({Key? key, required this.onSearchStarted}) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;
  
  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
      if (_focusNode.hasFocus) {
        widget.onSearchStarted();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iMat = context.read<ImatDataHandler>();

    return Container(
      height: 40,
      constraints: const BoxConstraints(maxWidth: 500),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: _isFocused 
              ? AppTheme.colorScheme.primary 
              : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        decoration: InputDecoration(
          hintText: 'Sök efter produkter...',
          hintStyle: TextStyle(
            color: AppTheme.colorScheme.onSurface.withOpacity(0.6),
          ),
          prefixIcon: Icon(
            Icons.search,
            color: AppTheme.colorScheme.onSurface.withOpacity(0.8),
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: AppTheme.colorScheme.onSurface.withOpacity(0.8),
                  ),
                  onPressed: () {
                    _controller.clear();
                    widget.onSearchStarted();
                    final results = iMat.findProducts('');
                    iMat.selectSelection(results);
                  },
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
          isDense: true,
        ),
        style: TextStyle(
          color: AppTheme.colorScheme.onSurface,
          fontSize: 16,
        ),
        onChanged: (value) {
          setState(() {});
          widget.onSearchStarted();
          final results = iMat.findProducts(value);
          iMat.selectSelection(results);
        },
        textAlignVertical: TextAlignVertical.center,
      ),
    );
  }
}
