import 'package:flutter/material.dart';
import 'package:imat_app/widgets/close-button.dart';
import 'package:imat_app/widgets/cart_button.dart'; // ✅ Add import for AddToCartButton
import '../../model/imat_data_handler.dart';

void showFavoritesDialog(BuildContext context, ImatDataHandler dataHandler) {
  final favorites = dataHandler.favorites;

  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Center(
        child: Material(
          color: Colors.transparent,
          child: Stack(
            children: [
              Container(
                width: 800,
                height: 600,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.teal, width: 5),
                ),
                clipBehavior: Clip.antiAlias,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Center(
                        child: Text(
                          'Favoriter',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const Divider(thickness: 1.5),
                    if (favorites.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(12),
                        child: Text('Inga favoriter ännu.'),
                      )
                    else
                      Expanded(
                        child: ListView.builder(
                          itemCount: favorites.length,
                          itemBuilder: (context, index) {
                            final product = favorites[index];
                            return ListTile(
                              leading: SizedBox(
                                width: 40,
                                height: 40,
                                child: dataHandler.getImage(product),
                              ),
                              title: Text(product.name),
                              subtitle: Text(
                                '${product.price.toStringAsFixed(2)} kr',
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  AddToCartButton(
                                    product: product,
                                  ), // ✅ Add your custom button
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    onPressed: () {
                                      dataHandler.toggleFavorite(product);
                                      Navigator.pop(context);
                                      showFavoritesDialog(context, dataHandler);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    const Divider(thickness: 1.5),
                  ],
                ),
              ),
              Positioned(
                bottom: 12,
                left: 12,
                child: CloseButtonWidget(
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
