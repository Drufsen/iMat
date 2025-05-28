import 'package:flutter/material.dart';
import 'package:imat_app/widgets/scalable_text.dart';

class DeliveryInfoStep extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final Function(Map<String, String>) onDataChanged;
  final Map<String, String>? initialData; // New optional initial data

  const DeliveryInfoStep({
    super.key,
    required this.formKey,
    required this.onDataChanged,
    this.initialData,
  });

  @override
  State<DeliveryInfoStep> createState() => _DeliveryInfoStepState();
}

class _DeliveryInfoStepState extends State<DeliveryInfoStep> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final phoneController = TextEditingController();
  final mobileController = TextEditingController();
  final emailController = TextEditingController();
  final addressController = TextEditingController();
  final postCodeController = TextEditingController();
  final postAddressController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _populateInitialData();
    _addListeners();
  }

  void _populateInitialData() {
    final data = widget.initialData ?? {};

    firstNameController.text = data['firstName'] ?? '';
    lastNameController.text = data['lastName'] ?? '';
    phoneController.text = data['phone'] ?? '';
    mobileController.text = data['mobile'] ?? '';
    emailController.text = data['email'] ?? '';
    addressController.text = data['address'] ?? '';
    postCodeController.text = data['postCode'] ?? '';
    postAddressController.text = data['postAddress'] ?? '';
  }

  void _addListeners() {
    final controllers = [
      firstNameController,
      lastNameController,
      phoneController,
      mobileController,
      emailController,
      addressController,
      postCodeController,
      postAddressController,
    ];
    for (final controller in controllers) {
      controller.addListener(_updateData);
    }
  }

  void _updateData() {
    widget.onDataChanged({
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'phone': phoneController.text,
      'mobile': mobileController.text,
      'email': emailController.text,
      'address': addressController.text,
      'postCode': postCodeController.text,
      'postAddress': postAddressController.text,
    });
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    mobileController.dispose();
    emailController.dispose();
    addressController.dispose();
    postCodeController.dispose();
    postAddressController.dispose();
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
              "Leveransinformation:",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: [
                _buildValidatedField("Förnamn", firstNameController, 200),
                _buildValidatedField("Efternamn", lastNameController, 200),
                _buildOptionalField("Telefonnummer", phoneController, 200),
                _buildOptionalField("Mobilnummer", mobileController, 200),
                _buildValidatedField("E-post", emailController, 420),
                _buildValidatedField("Adress", addressController, 420),
                _buildValidatedField("Postnummer", postCodeController, 200),
                _buildValidatedField("Postort", postAddressController, 200),
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

  Widget _buildValidatedField(
    String label,
    TextEditingController controller,
    double width,
  ) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        validator:
            (value) => value == null || value.isEmpty ? 'Måste fyllas i' : null,
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

  Widget _buildOptionalField(
    String label,
    TextEditingController controller,
    double width,
  ) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
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
