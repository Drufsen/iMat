import 'package:flutter/material.dart';
import 'package:imat_app/widgets/add_to_cart_button.dart';
import 'package:imat_app/widgets/close-button.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat/product.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/scalable_text.dart';

class ProductDetailDialog extends StatelessWidget {
  final Product product;

  const ProductDetailDialog({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final detail = iMat.getDetail(product);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      insetPadding: const EdgeInsets.all(24),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            SizedBox(
              width: 420,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: SizedBox(height: 200, child: iMat.getImage(product)),
                  ),
                  const SizedBox(height: 16),
                  ScalableText(
                    product.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ScalableText(
                    '${product.price.toStringAsFixed(2)} ${product.unit}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  const SizedBox(height: 16),

                  if (detail != null) ...[
                    _detailRow("Märke", detail.brand),
                    _detailRow("Innehåll", detail.contents),
                    _detailRow("Ursprung", detail.origin),
                    const SizedBox(height: 16),
                    ScalableText(
                      detail.description,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ] else
                    ScalableText(
                      "Ingen beskrivning tillgänglig.",
                      style: const TextStyle(fontSize: 16),
                    ),

                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CloseButtonWidget(),
                      AddToCartButton(product: product),
                    ],
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          ScalableText(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: ScalableText(
              value.isNotEmpty ? value : "-",
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
