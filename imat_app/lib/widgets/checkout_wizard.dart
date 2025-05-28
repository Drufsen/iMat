import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/credit_card.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:imat_app/widgets/cart_review.dart';
import 'package:imat_app/widgets/confirmation.dart';
import 'package:imat_app/widgets/delivery_info.dart';
import 'package:imat_app/widgets/payment.dart';
import 'package:imat_app/widgets/scalable_text.dart';
import 'package:provider/provider.dart';
import 'package:imat_app/widgets/step_progress_bar.dart';
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

  DateTime? _selectedDate;
  String? _selectedTimeSlot;

  final _deliveryFormKey = GlobalKey<FormState>();
  final _paymentFormKey = GlobalKey<FormState>();

  Future<void> _pickDate(BuildContext context) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectTimeSlot(String slot) {
    setState(() {
      _selectedTimeSlot = slot;
    });
  }

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
        await _finalizeOrder(iMat);
      }
    }
  }

  void _previousStep() {
    if (_step > 0) setState(() => _step--);
  }

  Future<void> _finalizeOrder(ImatDataHandler iMat) async {
    await iMat.placeOrder();
    if (mounted) {
      Navigator.pop(context);
    }
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
        width: 700,
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              StepProgressBar(currentStep: _step, totalSteps: totalSteps),
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
                          foregroundColor: AppTheme.colorScheme.onPrimary,
                        ),
                        child: const ScalableText("Tillbaka"),
                      ),
                  ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.teal,
                      foregroundColor: AppTheme.colorScheme.onPrimary,
                    ),
                    child: ScalableText(_step == totalSteps - 1 ? "Slutför" : "Nästa"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    final steps = [
      const CartReviewStep(),
      DeliveryInfoStep(formKey: _deliveryFormKey),
      PaymentStep(formKey: _paymentFormKey),
      ConfirmationStep(
        selectedDate: _selectedDate,
        selectedTimeSlot: _selectedTimeSlot,
        onDateSelected: _pickDate,
        onTimeSlotSelected: _selectTimeSlot,
      ),
    ];
    return steps[_step];
  }
}
