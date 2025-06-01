import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/car_item_tile.dart';
import 'package:imat_app/widgets/cart_total_row.dart';
import 'package:imat_app/widgets/checkout_wizard.dart';
import 'package:imat_app/widgets/close-button.dart';
import 'package:imat_app/widgets/empty_cart_message.dart';
import 'package:imat_app/widgets/rensa_button.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class CartPopupMenu extends StatelessWidget {
  final VoidCallback? onClose;

  const CartPopupMenu({super.key, this.onClose});

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final items = iMat.getShoppingCart().items;

    if (items.isEmpty) return EmptyCartMessage(onClose: onClose);

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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 🧾 Scrollable item list
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder:
                      (context, index) => CartItemTile(item: items[index]),
                ),
              ),
            ),

            // 🛒 Button group fixed at the bottom
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Align(
                alignment: Alignment.center,
                child: RensaButton(
                  onPressed: () {
                    iMat.shoppingCartClear(); // Clear cart logic
                  },
                ),
              ),
            ),

            const Divider(thickness: 1.5),
            const CartTotalRow(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CloseButtonWidget(onPressed: onClose),
                  ElevatedButton.icon(
                    onPressed: () {
                      if (onClose != null) {
                        onClose!(); // Close cart before opening checkout
                      }
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => const CheckoutWizard(),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: AppTheme.colorScheme.onPrimary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    icon: const Icon(Icons.payment),
                    label: const Text("Betala"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
