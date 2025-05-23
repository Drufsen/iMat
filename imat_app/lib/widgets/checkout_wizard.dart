import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/widgets/close-button.dart';
import 'package:imat_app/model/imat_data_handler.dart';
import 'package:imat_app/model/imat/shopping_item.dart';

class CheckoutWizard extends StatefulWidget {
  const CheckoutWizard({super.key});

  @override
  State<CheckoutWizard> createState() => _CheckoutWizardState();
}

class _CheckoutWizardState extends State<CheckoutWizard> {
  int _step = 0;
  final int totalSteps = 4;

  void _nextStep() {
    if (_step < totalSteps - 1) {
      setState(() => _step++);
    } else {
      Navigator.pop(context);
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

  Widget _buildDeliveryInfoStep() => const Text("2. Leveransinformation");

  Widget _buildPaymentStep() => const Text("3. Betalningsmetod");

  Widget _buildConfirmationStep() => const Text("4. Bekräftelse");
}
