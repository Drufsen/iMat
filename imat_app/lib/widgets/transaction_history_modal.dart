import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';

class TransactionHistoryModal extends StatefulWidget {
  const TransactionHistoryModal({super.key});

  @override
  State<TransactionHistoryModal> createState() =>
      _TransactionHistoryModalState();
}

class _TransactionHistoryModalState extends State<TransactionHistoryModal> {
  final List<Transaction> _transactions = [
    Transaction(
      id: '1001',
      date: DateTime(2025, 5, 20),
      totalAmount: 328.50,
      items: [
        TransactionItem(name: 'Mjölk', quantity: 2, price: 15.90),
        TransactionItem(name: 'Bröd', quantity: 1, price: 29.90),
        TransactionItem(name: 'Ägg 12-pack', quantity: 1, price: 45.90),
        TransactionItem(name: 'Tomater', quantity: 3, price: 12.90),
        TransactionItem(name: 'Pasta', quantity: 2, price: 19.90),
        TransactionItem(name: 'Köttfärs', quantity: 1, price: 89.90),
        TransactionItem(name: 'Juice', quantity: 1, price: 25.90),
      ],
    ),
    Transaction(
      id: '994',
      date: DateTime(2025, 5, 17),
      totalAmount: 159.60,
      items: [
        TransactionItem(name: 'Kaffe', quantity: 1, price: 49.90),
        TransactionItem(name: 'Yoghurt', quantity: 2, price: 22.90),
        TransactionItem(name: 'Äpple', quantity: 5, price: 5.90),
        TransactionItem(name: 'Banan', quantity: 3, price: 4.90),
      ],
    ),
    Transaction(
      id: '982',
      date: DateTime(2025, 5, 10),
      totalAmount: 423.70,
      items: [
        TransactionItem(name: 'Kyckling', quantity: 1, price: 99.90),
        TransactionItem(name: 'Ris', quantity: 1, price: 32.90),
        TransactionItem(name: 'Olivolja', quantity: 1, price: 79.90),
        TransactionItem(name: 'Diskmedel', quantity: 1, price: 34.90),
        TransactionItem(name: 'Tvättmedel', quantity: 1, price: 69.90),
        TransactionItem(name: 'Toalettpapper', quantity: 1, price: 106.20),
      ],
    ),
    Transaction(
      id: '965',
      date: DateTime(2025, 5, 3),
      totalAmount: 267.80,
      items: [
        TransactionItem(name: 'Chips', quantity: 2, price: 29.90),
        TransactionItem(name: 'Läsk', quantity: 3, price: 19.90),
        TransactionItem(name: 'Glass', quantity: 1, price: 49.90),
        TransactionItem(name: 'Godis', quantity: 1, price: 59.90),
        TransactionItem(name: 'Popcorn', quantity: 2, price: 19.90),
      ],
    ),
  ];

  int _selectedTransactionIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  Widget contentBox(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: AppTheme.colorScheme.background,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
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
                Text(
                  'Köphistorik',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.colorScheme.onPrimary,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(
                    Icons.close,
                    color: AppTheme.colorScheme.onPrimary,
                    size: 28,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left side - Transaction list
                Container(
                  width: 275,
                  decoration: BoxDecoration(
                    border: Border(
                      right: BorderSide(
                        color: AppTheme.colorScheme.outline,
                        width: 1,
                      ),
                    ),
                  ),
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    itemCount: _transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = _transactions[index];
                      final isSelected = index == _selectedTransactionIndex;

                      return ListTile(
                        tileColor:
                            isSelected
                                ? AppTheme.colorScheme.primaryContainer
                                : Colors.transparent,
                        // leading: CircleAvatar(
                        //   backgroundColor: AppTheme.colorScheme.primary,
                        //   child: Text(
                        //     (index + 1).toString(),
                        //     style: TextStyle(
                        //       color: AppTheme.colorScheme.onPrimary,
                        //       fontWeight: FontWeight.bold,
                        //     ),
                        //   ),
                        // ),
                        title: Text(
                          '${transaction.dateFormatted} | ${transaction.totalAmount.toStringAsFixed(2)} kr',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('Kvitto #${transaction.id}'),
                        onTap: () {
                          setState(() {
                            _selectedTransactionIndex = index;
                          });
                        },
                      );
                    },
                  ),
                ),

                // Right side - Receipt detail
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      24,
                      16,
                      24,
                      12,
                    ), // Further reduced padding, especially top/bottom
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Update the title and date section with swapped positions
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  '${_transactions[_selectedTransactionIndex].dateFormatted}',
                                  style: const TextStyle(
                                    fontSize:
                                        18, // Keep the larger font size for the date
                                    fontWeight:
                                        FontWeight.bold, // Keep the date bold
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  'Kvitto #${_transactions[_selectedTransactionIndex].id}',
                                  style: TextStyle(
                                    fontSize:
                                        15, // Smaller font for the receipt number
                                    color:
                                        AppTheme
                                            .colorScheme
                                            .onSurfaceVariant, // Use the secondary color
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ), // Even less space since we removed one row
                        const Divider(
                          thickness: 1,
                          height: 1,
                        ), // Thinner divider with no height
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                          ), // Minimal padding
                          child: Row(
                            children: [
                              const Expanded(
                                flex: 4,
                                child: Text(
                                  'Produkt',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15, // Slightly smaller header
                                  ),
                                ),
                              ),
                              const Expanded(
                                flex: 1,
                                child: Text(
                                  'Antal',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15, // Slightly smaller header
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const Expanded(
                                flex: 2,
                                child: Text(
                                  'á-pris',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15, // Slightly smaller header
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  'Summa',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15, // Slightly smaller header
                                  ),
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          height: 1,
                        ), // Thinner divider with no height
                        Expanded(
                          child: ListView.builder(
                            itemCount:
                                _transactions[_selectedTransactionIndex]
                                    .items
                                    .length,
                            itemBuilder: (context, index) {
                              final item =
                                  _transactions[_selectedTransactionIndex]
                                      .items[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4,
                                ), // Minimal spacing between items
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 4,
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ), // Slightly smaller text
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Text(
                                        '${item.quantity} st',
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ), // Slightly smaller text
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '${item.price.toStringAsFixed(2)} kr',
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ), // Slightly smaller text
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Text(
                                        '${(item.price * item.quantity).toStringAsFixed(2)} kr',
                                        style: const TextStyle(
                                          fontSize: 15,
                                        ), // Slightly smaller text
                                        textAlign: TextAlign.right,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ),
                        const Divider(
                          thickness: 1,
                          height: 1,
                        ), // Thinner divider with no height
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 8,
                            bottom: 0,
                          ), // Minimal padding, especially at bottom
                          child: Row(
                            children: [
                              const Spacer(flex: 5),
                              const Text(
                                'Totalt:',
                                style: TextStyle(
                                  fontSize: 16, // Smaller total
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '${_transactions[_selectedTransactionIndex].totalAmount.toStringAsFixed(2)} kr',
                                style: const TextStyle(
                                  fontSize: 16, // Smaller total
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            decoration: BoxDecoration(
              color: AppTheme.colorScheme.surface,
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Kvitto skickat till din e-post'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.email),
                      label: const Text('Skicka via e-post'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colorScheme.secondary,
                        foregroundColor: AppTheme.colorScheme.onSecondary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Kvitto sparat som PDF'),
                          ),
                        );
                      },
                      icon: const Icon(Icons.picture_as_pdf),
                      label: const Text('Spara som PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.colorScheme.primary,
                        foregroundColor: AppTheme.colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Transaction {
  final String id;
  final DateTime date;
  final double totalAmount;
  final List<TransactionItem> items;

  Transaction({
    required this.id,
    required this.date,
    required this.totalAmount,
    required this.items,
  });

  String get dateFormatted {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

class TransactionItem {
  final String name;
  final int quantity;
  final double price;

  TransactionItem({
    required this.name,
    required this.quantity,
    required this.price,
  });
}
