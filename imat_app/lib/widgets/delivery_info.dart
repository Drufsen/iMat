import 'package:flutter/material.dart';
import 'package:imat_app/widgets/scalable_text.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class DeliveryInfoStep extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const DeliveryInfoStep({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    final iMat = context.watch<ImatDataHandler>();
    final customer = iMat.getCustomer();

    final firstNameController = TextEditingController(text: customer.firstName);
    final lastNameController = TextEditingController(text: customer.lastName);
    final phoneController = TextEditingController(text: customer.phoneNumber);
    final mobileController = TextEditingController(
      text: customer.mobilePhoneNumber,
    );
    final emailController = TextEditingController(text: customer.email);
    final addressController = TextEditingController(text: customer.address);
    final postCodeController = TextEditingController(text: customer.postCode);
    final postAddressController = TextEditingController(
      text: customer.postAddress,
    );

    return SingleChildScrollView(
      child: Form(
        key: formKey,
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
