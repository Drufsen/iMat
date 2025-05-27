// lib/widgets/search_bar_widget.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final iMat = context.read<ImatDataHandler>();
    final searchController = TextEditingController();

    return SizedBox(
      height: 40,
      width: 500,
      child: TextField(
        controller: searchController,
        onChanged: (value) {
          final results = iMat.findProducts(value);
          iMat.selectSelection(
            results,
          ); // Update filtered products in ImatDataHandler
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
        ),
      ),
    );
  }
}
