import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/scalable_text.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class ConfirmationStep extends StatelessWidget {
  final DateTime? selectedDate;
  final String? selectedTimeSlot;
  final void Function(BuildContext) onDateSelected;
  final void Function(String) onTimeSlotSelected;

  const ConfirmationStep({
    super.key,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.onDateSelected,
    required this.onTimeSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final customer = iMat.getCustomer();
    final card = iMat.getCreditCard();
    final cart = iMat.getShoppingCart();
    final total = iMat.shoppingCartTotal().toStringAsFixed(2);

    final timeSlots = [
      '08:00–10:00',
      '10:00–12:00',
      '12:00–14:00',
      '14:00–16:00',
      '16:00–18:00',
      '18:00–20:00',
      '20:00–22:00',
    ];

    return SingleChildScrollView(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Customer + delivery info
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ScalableText(
                  "Bekräftelse",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ScalableText("Namn: ${customer.firstName} ${customer.lastName}"),
                ScalableText(
                  "Adress: ${customer.address}, ${customer.postCode} ${customer.postAddress}",
                ),
                ScalableText("Telefon: ${customer.phoneNumber}"),
                const SizedBox(height: 12),
                ScalableText(
                  "Kort: ${card.cardType} •••• ${card.cardNumber.substring(card.cardNumber.length - 4)}",
                ),
                ScalableText("Giltig till: ${card.validMonth}/${card.validYear}"),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                const ScalableText(
                  "Välj leveransdatum:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () => onDateSelected(context),
                  child: ScalableText(
                    selectedDate == null
                        ? "Välj datum"
                        : "${selectedDate!.day}/${selectedDate!.month} ${selectedDate!.year}",
                  ),
                ),
                const SizedBox(height: 16),
                const ScalableText(
                  "Välj leveranstid:",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children:
                      timeSlots.map((slot) {
                        final isSelected = selectedTimeSlot == slot;
                        return ChoiceChip(
                          label: ScalableText(slot),
                          selected: isSelected,
                          onSelected: (_) => onTimeSlotSelected(slot),
                          selectedColor: AppTheme.brand,
                          backgroundColor: AppTheme.colorScheme.tertiaryContainer,
                          labelStyle: TextStyle(
                            color: isSelected ? AppTheme.colorScheme.onPrimary : Colors.black,
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 16),
                if (selectedDate != null && selectedTimeSlot != null)
                  ScalableText(
                    "Leverans: ${selectedDate!.day}/${selectedDate!.month} ${selectedDate!.year} kl. $selectedTimeSlot",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 24),
          // Right side: Cart summary
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ScalableText(
                  "Kundvagn:",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                const SizedBox(height: 8),
                Container(
                  constraints: const BoxConstraints(maxHeight: 250),
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      final item = cart.items[index];
                      return ScalableText(
                        "${item.amount.toInt()} x ${item.product.name} (${(item.amount * item.product.price).toStringAsFixed(2)} kr)",
                      );
                    },
                  ),
                ),
                const SizedBox(height: 12),
                ScalableText(
                  "Totalt: $total kr",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
