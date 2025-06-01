import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/order.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/widgets/close-button.dart';
import 'package:imat_app/widgets/scalable_text.dart';
import 'package:provider/provider.dart';

class OrderHistoryModal extends StatefulWidget {
  const OrderHistoryModal({super.key});

  @override
  State<OrderHistoryModal> createState() => _OrderHistoryModalState();
}

class _OrderHistoryModalState extends State<OrderHistoryModal> {
  int _selectedOrderIndex = 0;

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final orders = iMat.orders;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child:
          orders.isEmpty
              ? Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppTheme.colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.border, width: 5),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const ScalableText(
                        "Ingen köphistorik ännu.",
                        style: TextStyle(fontSize: 16),
                      ),
                      const SizedBox(height: 16),
                      CloseButtonWidget(
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              )
              : _contentBox(context, iMat, orders),
    );
  }

  Widget _contentBox(
    BuildContext context,
    ImatDataHandler iMat,
    List<Order> orders,
  ) {
    // Sort orders by date (newest first)
    final sortedOrders = List<Order>.from(orders)
      ..sort((a, b) => b.date.compareTo(a.date));

    final selectedOrder = sortedOrders[_selectedOrderIndex];

    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: AppTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.border, width: 5),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderList(sortedOrders), // Pass the sorted list
                _buildOrderDetails(selectedOrder),
              ],
            ),
          ),
          const Divider(thickness: 1.5),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CloseButtonWidget(onPressed: () => Navigator.of(context).pop()),
                ElevatedButton.icon(
                  onPressed: () {
                    // Add all items from the selected order to the cart
                    for (final item in selectedOrder.items) {
                      iMat.shoppingCartAdd(item);
                    }
                    Navigator.of(context).pop(); // Close modal after adding
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.brand,
                    foregroundColor: AppTheme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    textStyle: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text("Lägg till i kundvagn"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity, // ✅ Fill full width
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.brand, // ✅ Match border color
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ScalableText(
            'Köphistorik',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color:
                  AppTheme.colorScheme.onPrimary, // ✅ White text for contrast
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    // Sort orders by date (newest first)
    final sortedOrders = List<Order>.from(orders)
      ..sort((a, b) => b.date.compareTo(a.date));

    return LayoutBuilder(
      builder: (context, parentConstraints) {
        // Calculate a dynamic width based on text scale factor
        final textScaleFactor = MediaQuery.textScaleFactorOf(context);

        // Calculate width needed for the longest text
        final longestOrderText = sortedOrders
            .map((order) {
              return '${order.date.year}-${order.date.month.toString().padLeft(2, '0')}-${order.date.day.toString().padLeft(2, '0')} | ${order.getTotal().toStringAsFixed(2)} kr';
            })
            .reduce((a, b) => a.length > b.length ? a : b);

        // Increase the per-character width estimate for better accommodation
        // Using 12 pixels per character instead of 10
        final perCharWidth = 12.0;
        final textWidth =
            longestOrderText.length * perCharWidth * textScaleFactor;

        // Add more padding for larger text sizes
        final buttonPadding = 40 + (40 * (textScaleFactor - 1));
        final baseWidth = textWidth + buttonPadding + 60;

        // Allow the width to grow more for large text sizes
        // If textScaleFactor > 1.5, allow even more width expansion
        final maxWidthProportion = textScaleFactor > 1.5 ? 0.5 : 0.4;
        final width = baseWidth.clamp(
          325.0,
          parentConstraints.maxWidth * maxWidthProportion,
        );

        return Container(
          // Width now depends on both text scale factor and content length
          width: width,
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(color: AppTheme.colorScheme.outline, width: 1),
            ),
          ),
          child: ListView.builder(
            itemCount: sortedOrders.length,
            itemBuilder: (context, index) {
              final order = sortedOrders[index];
              final isSelected = index == _selectedOrderIndex;

              return Material(
                elevation: isSelected ? 2 : 0,
                color:
                    isSelected
                        ? AppTheme.colorScheme.secondaryContainer
                        : Colors.transparent,
                child: ListTile(
                  title: ScalableText(
                    '${order.date.year}-${order.date.month.toString().padLeft(2, '0')}-${order.date.day.toString().padLeft(2, '0')} | ${order.getTotal().toStringAsFixed(2)} kr',
                    style: const TextStyle(fontSize: 18),
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: ScalableText(
                    'Kvitto #${order.orderNumber}',
                    style: const TextStyle(fontSize: 18),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      _removeOrder(context, order);
                    },
                    iconSize: 22 * textScaleFactor,
                    padding: EdgeInsets.zero,
                    constraints: BoxConstraints(
                      minWidth: 40 * textScaleFactor,
                      minHeight: 40 * textScaleFactor,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 4,
                  ),
                  dense: true,
                  onTap: () {
                    setState(() {
                      _selectedOrderIndex = index;
                    });
                  },
                ),
              );
            },
          ),
        );
      },
    );
  }

  void _removeOrder(BuildContext context, Order order) {
    final iMat = context.read<ImatDataHandler>();
    iMat.removeOrder(order); // Use the proper method

    setState(() {
      if (_selectedOrderIndex >= iMat.orders.length) {
        _selectedOrderIndex =
            (iMat.orders.isEmpty ? 0 : iMat.orders.length - 1);
      }
    });
  }

  Widget _buildOrderDetails(Order order) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ScalableText(
              '${order.date.year}-${order.date.month.toString().padLeft(2, '0')}-${order.date.day.toString().padLeft(2, '0')}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ScalableText(
              'Kvitto #${order.orderNumber}',
              style: const TextStyle(fontSize: 18),
            ),
            const Divider(thickness: 1),
            Expanded(
              child: ListView.builder(
                itemCount: order.items.length,
                itemBuilder: (context, index) {
                  final item = order.items[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: ScalableText(
                            item.product.name,
                            style: const TextStyle(fontSize: 18),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: ScalableText(
                            '${item.amount.toInt()} ${item.product.unit.replaceFirst("kr/", "")}',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: ScalableText(
                            '${item.product.price.toStringAsFixed(2)} kr',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: ScalableText(
                            '${(item.product.price * item.amount).toStringAsFixed(2)} kr',
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 18),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const Divider(thickness: 1),
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  const Spacer(flex: 5),
                  ScalableText(
                    'Totalt:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(width: 12),
                  ScalableText(
                    '${order.getTotal().toStringAsFixed(2)} kr',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
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
