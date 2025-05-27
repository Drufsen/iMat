import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/widgets/scalable_text.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class PaymentStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const PaymentStep({super.key, required this.formKey});

  @override
  State<PaymentStep> createState() => _PaymentStepState();
}

class _PaymentStepState extends State<PaymentStep> {
  late String selectedCardType;
  late String selectedMonth;
  late String selectedYear;

  @override
  void initState() {
    super.initState();
    final creditCard = context.read<ImatDataHandler>().getCreditCard();
    selectedCardType =
        creditCard.cardType.isNotEmpty ? creditCard.cardType : 'Visa';
    selectedMonth = creditCard.validMonth.toString().padLeft(2, '0');
    selectedYear = creditCard.validYear.toString();
  }

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final creditCard = iMat.getCreditCard();

    final holderNameController = TextEditingController(
      text: creditCard.holdersName,
    );
    final cardNumberController = TextEditingController(
      text: creditCard.cardNumber,
    );
    final verificationCodeController = TextEditingController(
      text: creditCard.verificationCode.toString(),
    );

    return SingleChildScrollView(
      child: Form(
        key: widget.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ScalableText(
              "Betalningsinformation:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildDropdownField(
                  label: "Korttyp",
                  value: selectedCardType,
                  items: ['Visa', 'Mastercard'],
                  onChanged: (value) {
                    if (value != null) {
                      setState(() => selectedCardType = value);
                    }
                  },
                ),
                _buildValidatedField(
                  "Korthållarens namn",
                  holderNameController,
                  300,
                  (value) =>
                      value == null || value.isEmpty ? "Måste fyllas i" : null,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDropdownField(
                      label: "Giltig månad (MM)",
                      value: selectedMonth,
                      items: List.generate(
                        12,
                        (index) => (index + 1).toString().padLeft(2, '0'),
                      ),
                      width: 140,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedMonth = value);
                        }
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildDropdownField(
                      label: "Giltigt år (ÅÅÅÅ)",
                      value: selectedYear,
                      items: List.generate(
                        16,
                        (index) => (2025 + index).toString(),
                      ),
                      width: 140,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => selectedYear = value);
                        }
                      },
                    ),
                  ],
                ),
                _buildValidatedField(
                  "Kortnummer",
                  cardNumberController,
                  300,
                  (value) {
                    if (value == null ||
                        value.length != 16 ||
                        int.tryParse(value) == null) {
                      return '16 siffror';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                _buildValidatedField(
                  "CVC-kod",
                  verificationCodeController,
                  140,
                  (value) {
                    if (value == null ||
                        value.length != 3 ||
                        int.tryParse(value) == null) {
                      return '3 siffror';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: ScalableText(
                "Vi sparar givna informationen för nästa gång du handlar hos oss.",
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    double width = 200,
  }) {
    return SizedBox(
      width: width,
      child: DropdownButtonFormField<String>(
        value: value,
        onChanged: onChanged,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
        ),
        items:
            items
                .map(
                  (item) =>
                      DropdownMenuItem(value: item, child: ScalableText(item)),
                )
                .toList(),
      ),
    );
  }

  Widget _buildValidatedField(
    String label,
    TextEditingController controller,
    double width,
    String? Function(String?) validator, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        validator: validator,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
        ),
      ),
    );
  }
}
