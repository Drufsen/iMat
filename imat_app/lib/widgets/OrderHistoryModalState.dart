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
                      const ScalableText("Ingen köphistorik ännu."),
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
              color: AppTheme.colorScheme.onPrimary, // ✅ White text for contrast
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
    
    return Container(
      width: 275,
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
              ),
              subtitle: ScalableText('Kvitto #${order.orderNumber}'),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  _removeOrder(context, order);
                },
              ),
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
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ScalableText('Kvitto #${order.orderNumber}'),
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
                          child: ScalableText(item.product.name),
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            '${item.amount.toInt()} ${item.product.unit.replaceFirst("kr/", "")}',
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: ScalableText(
                            '${item.product.price.toStringAsFixed(2)} kr',
                            textAlign: TextAlign.right,
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: ScalableText(
                            '${(item.product.price * item.amount).toStringAsFixed(2)} kr',
                            textAlign: TextAlign.right,
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
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 12),
                  ScalableText(
                    '${order.getTotal().toStringAsFixed(2)} kr',
                    style: const TextStyle(fontWeight: FontWeight.bold),
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
