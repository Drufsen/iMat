import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/order.dart';
import 'package:imat_app/model/imat_data_handler.dart';
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
    final orders = context.watch<ImatDataHandler>().orders;

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
                  ),
                  child: const ScalableText("Ingen köphistorik ännu."),
                ),
              )
              : _contentBox(context, orders),
    );
  }

  Widget _contentBox(BuildContext context, List<Order> orders) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: AppTheme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
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
          _buildHeader(context),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildOrderList(orders),
                _buildOrderDetails(orders[_selectedOrderIndex]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.colorScheme.primary,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ScalableText(
            'Köphistorik',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppTheme.colorScheme.onPrimary,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: Icon(Icons.close, color: AppTheme.colorScheme.onPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<Order> orders) {
    return Container(
      width: 275,
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: AppTheme.colorScheme.outline, width: 1),
        ),
      ),
      child: ListView.builder(
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
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
                        Expanded(flex: 4, child: ScalableText(item.product.name)),
                        Expanded(
                          flex: 1,
<<<<<<< HEAD
                          child: ScalableText(
                            '${item.amount.toInt()} st',
=======
                          child: Text(
                            '${item.amount.toInt()} ${item.product.unit.replaceFirst("kr/", "")}',
>>>>>>> ad2c87507525a13e703170a8e4b9a79230300bce
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
                  ScalableText('Totalt:', style: TextStyle(fontWeight: FontWeight.bold),
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
