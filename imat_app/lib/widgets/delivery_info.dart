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
                _buildSizedTextField("Förnamn", firstNameController, 200),
                _buildSizedTextField("Efternamn", lastNameController, 200),
                _buildSizedTextField("Telefonnummer", phoneController, 200),
                _buildSizedTextField("Mobilnummer", mobileController, 200),
                _buildSizedTextField("E-post", emailController, 420),
                _buildSizedTextField("Adress", addressController, 420),
                _buildSizedTextField("Postnummer", postCodeController, 200),
                _buildSizedTextField("Postort", postAddressController, 200),
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

  Widget _buildSizedTextField(
    String label,
    TextEditingController controller,
    double width,
  ) {
    return SizedBox(
      width: width,
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }
}
