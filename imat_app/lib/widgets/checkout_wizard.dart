import 'package:flutter/material.dart';

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
      setState(() {
        _step++;
      });
    } else {
      Navigator.pop(context);
    }
  }

  void _previousStep() {
    if (_step > 0) {
      setState(() {
        _step--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      _buildCartReviewStep(),
      _buildDeliveryInfoStep(),
      _buildPaymentStep(),
      _buildConfirmationStep(),
    ];

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
              // Progress bar
              LinearProgressIndicator(
                value: (_step + 1) / totalSteps,
                backgroundColor: Colors.teal.shade100,
                color: Colors.teal,
                minHeight: 8,
              ),
              const SizedBox(height: 24),

              // Step content
              steps[_step],
              const SizedBox(height: 24),

              // Navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (_step > 0)
                    ElevatedButton(
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

  Widget _buildCartReviewStep() => const Text("1. Granska kundvagn");

  Widget _buildDeliveryInfoStep() => const Text("2. Leveransinformation");

  Widget _buildPaymentStep() => const Text("3. Betalningsmetod");

  Widget _buildConfirmationStep() => const Text("4. Bekräftelse");
}
