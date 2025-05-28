import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class SearchBarWidget extends StatefulWidget {
  final VoidCallback onSearchStarted;

  const SearchBarWidget({super.key, required this.onSearchStarted});

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final iMat = context.read<ImatDataHandler>();

    return SizedBox(
      height: 40,
      width: 500,
      child: TextField(
        controller: _searchController,
        onChanged: (value) {
          widget.onSearchStarted();
          final results = iMat.findProducts(value);
          iMat.selectSelection(results);
        },
        decoration: InputDecoration(
          hintText: 'Sök efter produkter...',
          border: InputBorder.none,
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide.none,
          ),
          suffixIcon: IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              _searchController.clear();
              widget.onSearchStarted();
              final results = iMat.findProducts('');
              iMat.selectSelection(results);
            },
          ),
        ),
      ),
    );
  }
}
