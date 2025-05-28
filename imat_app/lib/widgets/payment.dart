import 'package:flutter/material.dart';
import 'package:imat_app/widgets/scalable_text.dart';

class PaymentStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(Map<String, dynamic>) onDataChanged;
  final Map<String, dynamic>? initialData;

  const PaymentStep({
    super.key,
    required this.formKey,
    required this.onDataChanged,
    this.initialData,
  });

  @override
  State<PaymentStep> createState() => _PaymentStepState();
}

class _PaymentStepState extends State<PaymentStep> {
  late String selectedCardType;
  late String selectedMonth;
  late String selectedYear;

  final holderNameController = TextEditingController();
  final cardNumberController = TextEditingController();
  final verificationCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();

    final data = widget.initialData ?? {};

    selectedCardType = data['cardType'] ?? 'Visa';
    selectedMonth = (data['validMonth'] ?? 1).toString().padLeft(2, '0');
    selectedYear = (data['validYear'] ?? 2025).toString();

    holderNameController.text = data['holdersName'] ?? '';
    cardNumberController.text = data['cardNumber'] ?? '';
    verificationCodeController.text =
        data['verificationCode']?.toString() ?? '';

    _addListeners();
  }

  void _addListeners() {
    holderNameController.addListener(_updateData);
    cardNumberController.addListener(_updateData);
    verificationCodeController.addListener(_updateData);
  }

  void _updateData() {
    widget.onDataChanged({
      'cardType': selectedCardType,
      'holdersName': holderNameController.text,
      'validMonth': int.tryParse(selectedMonth) ?? 1,
      'validYear': int.tryParse(selectedYear) ?? 2025,
      'cardNumber': cardNumberController.text,
      'verificationCode': int.tryParse(verificationCodeController.text) ?? 0,
    });
  }

  @override
  void dispose() {
    holderNameController.dispose();
    cardNumberController.dispose();
    verificationCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      setState(() {
                        selectedCardType = value;
                        _updateData();
                      });
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
                          setState(() {
                            selectedMonth = value;
                            _updateData();
                          });
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
                          setState(() {
                            selectedYear = value;
                            _updateData();
                          });
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
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
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
          border: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.teal, width: 2),
          ),
        ),
      ),
    );
  }
}
