import 'package:flutter/material.dart';
import 'package:imat_app/model/imat/credit_card.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/widgets/close-button.dart';
import 'package:imat_app/model/imat_data_handler.dart';

class CheckoutWizard extends StatefulWidget {
  const CheckoutWizard({super.key});

  @override
  State<CheckoutWizard> createState() => _CheckoutWizardState();
}

class _CheckoutWizardState extends State<CheckoutWizard> {
  int _step = 0;
  final int totalSteps = 4;

  void _saveCustomerData(ImatDataHandler iMat) {
    final customer = iMat.getCustomer();

    final updatedCustomer = Customer(
      customer.firstName,
      customer.lastName,
      customer.phoneNumber,
      customer.mobilePhoneNumber,
      customer.email,
      customer.address,
      customer.postCode,
      customer.postAddress,
    );
    iMat.setCustomer(updatedCustomer);
  }

  void _savePaymentData(ImatDataHandler iMat) {
    final creditCard = iMat.getCreditCard();

    final updatedCard = CreditCard(
      creditCard.cardType,
      creditCard.holdersName,
      creditCard.validMonth,
      creditCard.validYear,
      creditCard.cardNumber,
      creditCard.verificationCode,
    );
    iMat.setCreditCard(updatedCard);
  }

  final _deliveryFormKey = GlobalKey<FormState>();
  final _paymentFormKey = GlobalKey<FormState>();

  void _nextStep() async {
    final iMat = context.read<ImatDataHandler>();
    bool isValid = true;

    if (_step == 1) {
      isValid = _deliveryFormKey.currentState?.validate() ?? true;
      if (isValid) _saveCustomerData(iMat);
    } else if (_step == 2) {
      isValid = _paymentFormKey.currentState?.validate() ?? true;
      if (isValid) _savePaymentData(iMat);
    }

    if (isValid) {
      if (_step < totalSteps - 1) {
        setState(() => _step++);
      } else {
        await _finalizeOrder(iMat); // Vänta på att ordern är sparad
      }
    }
  }

  void _previousStep() {
    if (_step > 0) setState(() => _step--);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.teal, width: 5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: 500,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildStepProgressBar(),
              const SizedBox(height: 24),
              _buildStepContent(),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _step == 0
                      ? CloseButtonWidget(
                        onPressed: () => Navigator.pop(context),
                      )
                      : ElevatedButton(
                        onPressed: _previousStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text("Tillbaka"),
                      ),
                  ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_step == totalSteps - 1 ? "Slutför" : "Nästa"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepProgressBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(totalSteps * 2 - 1, (index) {
        if (index % 2 == 0) {
          final stepIndex = index ~/ 2;
          final isActive = stepIndex <= _step;
          return Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? Colors.teal : Colors.white,
              border: Border.all(color: Colors.teal, width: 2),
            ),
            alignment: Alignment.center,
            child: Text(
              '${stepIndex + 1}',
              style: TextStyle(
                color: isActive ? Colors.white : Colors.teal,
                fontWeight: FontWeight.bold,
              ),
            ),
          );
        } else {
          return Expanded(child: Container(height: 2, color: Colors.teal));
        }
      }),
    );
  }

  Widget _buildStepContent() {
    final steps = [
      _buildCartReviewStep(),
      _buildDeliveryInfoStep(),
      _buildPaymentStep(),
      _buildConfirmationStep(),
    ];
    return steps[_step];
  }

  Widget _buildCartReviewStep() {
    final iMat = context.watch<ImatDataHandler>();
    final items = iMat.getShoppingCart().items;

    if (items.isEmpty) {
      return const Text("Kundvagnen är tom.");
    }

    final total = iMat.shoppingCartTotal().toStringAsFixed(2);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Granska din kundvagn:",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          constraints: const BoxConstraints(maxHeight: 200),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              final product = item.product;
              final quantity = item.amount.toInt();
              final price = (item.amount * product.price).toStringAsFixed(2);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Row(
                  children: [
                    // Product image
                    Container(
                      width: 40,
                      height: 40,
                      margin: const EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(4),
                        image: DecorationImage(
                          image: iMat.getImage(product).image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Product info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "$quantity st • ${product.price.toStringAsFixed(2)} kr/st",
                          ),
                        ],
                      ),
                    ),
                    // Price and remove button
                    Column(
                      children: [
                        Text(
                          "$price kr",
                          style: const TextStyle(fontWeight: FontWeight.w500),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete,
                            size: 18,
                            color: Colors.redAccent,
                          ),
                          onPressed: () => iMat.shoppingCartRemove(item),
                          tooltip: "Ta bort",
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Totalt: $total kr",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildDeliveryInfoStep() {
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
        key: _deliveryFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
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

  Widget _buildPaymentStep() {
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

    String selectedCardType =
        creditCard.cardType.isNotEmpty ? creditCard.cardType : 'Visa';

    return SingleChildScrollView(
      child: Form(
        key: _paymentFormKey,
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
                  label: "Korthållarens namn",
                  controller: holderNameController,
                  width: 300,
                  validator:
                      (value) =>
                          (value == null || value.isEmpty)
                              ? "Måste fyllas i"
                              : null,
                ),

                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildValidatedField(
                      label: "Giltig månad (MM)",
                      controller: validMonthController,
                      width: 140,
                      validator: (value) {
                        final month = int.tryParse(value ?? '');
                        if (month == null || month < 1 || month > 12) {
                          return '1-12';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(width: 16),
                    _buildValidatedField(
                      label: "Giltigt år (ÅÅÅÅ)",
                      controller: validYearController,
                      width: 140,
                      validator: (value) {
                        final year = int.tryParse(value ?? '');
                        final currentYear = DateTime.now().year;
                        if (year == null || year < currentYear) {
                          return '$currentYear+';
                        }
                        return null;
                      },
                    ),
                  ],
                ),

                _buildValidatedField(
                  label: "Kortnummer",
                  controller: cardNumberController,
                  width: 300,
                  validator: (value) {
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
                  label: "CVC/CVV-kod",
                  controller: verificationCodeController,
                  width: 140,
                  validator: (value) {
                    if (value == null ||
                        (value.length != 3 && value.length != 4) ||
                        int.tryParse(value) == null) {
                      return '3-4 siffror';
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

  Widget _buildConfirmationStep() {
    final iMat = context.watch<ImatDataHandler>();
    final customer = iMat.getCustomer();
    final card = iMat.getCreditCard();
    final cart = iMat.getShoppingCart();

    final total = iMat.shoppingCartTotal().toStringAsFixed(2);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Bekräftelse",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text("Namn: ${customer.firstName} ${customer.lastName}"),
          Text(
            "Adress: ${customer.address}, ${customer.postCode} ${customer.postAddress}",
          ),
          Text("Telefon: ${customer.phoneNumber}"),
          const SizedBox(height: 12),
          Text(
            "Kort: ${card.cardType} •••• ${card.cardNumber.substring(card.cardNumber.length - 4)}",
          ),
          Text("Giltig till: ${card.validMonth}/${card.validYear}"),
          const SizedBox(height: 12),
          const Text(
            "Kundvagn:",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ...cart.items.map(
            (item) => Text(
              "${item.amount.toInt()} x ${item.product.name} (${(item.amount * item.product.price).toStringAsFixed(2)} kr)",
            ),
          ),
          const SizedBox(height: 12),
          Text(
            "Totalt: $total kr",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildValidatedField({
    required String label,
    required TextEditingController controller,
    required double width,
    required String? Function(String?) validator,
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

  Future<void> _finalizeOrder(ImatDataHandler iMat) async {
    await iMat.placeOrder();
    if (mounted) {
      Navigator.pop(context);
    }
  }
}
