import 'package:flutter/material.dart';
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

  @override
  void initState() {
    super.initState();
    final creditCard = context.read<ImatDataHandler>().getCreditCard();
    selectedCardType =
        creditCard.cardType.isNotEmpty ? creditCard.cardType : 'Visa';
  }

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final creditCard = iMat.getCreditCard();

    final holderNameController = TextEditingController(
      text: creditCard.holdersName,
    );
    final validMonthController = TextEditingController(
      text: creditCard.validMonth.toString(),
    );
    final validYearController = TextEditingController(
      text: creditCard.validYear.toString(),
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
            const Text(
              "Betalningsinformation:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<String>(
                    value: selectedCardType,
                    decoration: const InputDecoration(
                      labelText: 'Korttyp',
                      border: OutlineInputBorder(),
                    ),
                    items:
                        ['Visa', 'Mastercard']
                            .map(
                              (type) => DropdownMenuItem(
                                value: type,
                                child: Text(type),
                              ),
                            )
                            .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          selectedCardType = value;
                        });
                      }
                    },
                  ),
                ),
                _buildValidatedField(
                  "Korthållarens namn",
                  holderNameController,
                  300,
                  (value) {
                    if (value == null || value.isEmpty) return "Måste fyllas i";
                    return null;
                  },
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildValidatedField(
                      "Giltig månad (MM)",
                      validMonthController,
                      140,
                      (value) {
                        final month = int.tryParse(value ?? '');
                        if (month == null || month < 1 || month > 12)
                          return '1-12';
                        return null;
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildValidatedField(
                      "Giltigt år (ÅÅÅÅ)",
                      validYearController,
                      140,
                      (value) {
                        final year = int.tryParse(value ?? '');
                        final currentYear = DateTime.now().year;
                        if (year == null || year < currentYear)
                          return '$currentYear+';
                        return null;
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
                        int.tryParse(value) == null)
                      return '16 siffror';
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
                _buildValidatedField(
                  "CVC/CVV-kod",
                  verificationCodeController,
                  140,
                  (value) {
                    if (value == null ||
                        (value.length != 3 && value.length != 4) ||
                        int.tryParse(value) == null)
                      return '3-4 siffror';
                    return null;
                  },
                  keyboardType: TextInputType.number,
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                "Vi sparar givna informationen för nästa gång du handlar hos oss.",
                style: TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
              ),
            ),
          ],
        ),
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
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
