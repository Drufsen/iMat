import 'package:flutter/material.dart';
import 'package:imat_app/app_theme.dart';
import 'package:imat_app/model/imat/credit_card.dart';
import 'package:imat_app/model/imat/customer.dart';
import 'package:imat_app/widgets/cart_review.dart';
import 'package:imat_app/widgets/confirmation.dart';
import 'package:imat_app/widgets/delivery_info.dart';
import 'package:imat_app/widgets/payment.dart';
import 'package:imat_app/widgets/scalable_text.dart';
import 'package:imat_app/widgets/success_step.dart';
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

  Map<String, String> _deliveryFormData = {};
  Map<String, dynamic> _paymentFormData = {};

  bool _isOrderCompleted = false;

  // Add state variables to track validation
  bool _deliveryFormValid = false;
  bool _paymentFormValid = false;

  @override
  void initState() {
    super.initState();
    final iMat = context.read<ImatDataHandler>();

    // Preload customer and credit card data
    final customer = iMat.getCustomer();
    _deliveryFormData = {
      'firstName': customer.firstName,
      'lastName': customer.lastName,
      'phone': customer.phoneNumber,
      'mobile': customer.mobilePhoneNumber,
      'email': customer.email,
      'address': customer.address,
      'postCode': customer.postCode,
      'postAddress': customer.postAddress,
    };

    final creditCard = iMat.getCreditCard();
    _paymentFormData = {
      'cardType': creditCard.cardType,
      'holdersName': creditCard.holdersName,
      'validMonth': creditCard.validMonth,
      'validYear': creditCard.validYear,
      'cardNumber': creditCard.cardNumber,
      'verificationCode': creditCard.verificationCode,
    };
  }

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

  void _nextStep() async {
    final iMat = context.read<ImatDataHandler>();
    bool isValid = true;

    if (_step == 1) {
      isValid = _deliveryFormKey.currentState?.validate() ?? true;
      if (isValid) {
        final updatedCustomer = Customer(
          _deliveryFormData['firstName'] ?? '',
          _deliveryFormData['lastName'] ?? '',
          _deliveryFormData['phone'] ?? '',
          _deliveryFormData['mobile'] ?? '',
          _deliveryFormData['email'] ?? '',
          _deliveryFormData['address'] ?? '',
          _deliveryFormData['postCode'] ?? '',
          _deliveryFormData['postAddress'] ?? '',
        );
        iMat.setCustomer(updatedCustomer);
      }
    } else if (_step == 2) {
      isValid = _paymentFormKey.currentState?.validate() ?? true;
      if (isValid) {
        final updatedCard = CreditCard(
          _paymentFormData['cardType'] ?? '',
          _paymentFormData['holdersName'] ?? '',
          _paymentFormData['validMonth'] ?? 1,
          _paymentFormData['validYear'] ?? 2025,
          _paymentFormData['cardNumber'] ?? '',
          _paymentFormData['verificationCode'] ?? 0,
        );
        iMat.setCreditCard(updatedCard);
      }
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
      setState(() {
        _isOrderCompleted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final steps = [
      const CartReviewStep(),
      DeliveryInfoStep(
        formKey: _deliveryFormKey,
        onDataChanged: (data) => _deliveryFormData = data,
        initialData: _deliveryFormData,
        onValidationChanged: (isValid) {
          setState(() {
            _deliveryFormValid = isValid;
          });
        },
      ),
      PaymentStep(
        formKey: _paymentFormKey,
        onDataChanged: (data) => _paymentFormData = data,
        initialData: _paymentFormData,
        onValidationChanged: (isValid) {
          setState(() {
            _paymentFormValid = isValid;
          });
        },
      ),
      ConfirmationStep(
        selectedDate: _selectedDate,
        selectedTimeSlot: _selectedTimeSlot,
        onDateSelected: _pickDate,
        onTimeSlotSelected: _selectTimeSlot,
      ),
    ];

    // Then in your UI, update the Next button based on form validity
    bool isNextEnabled =
        _step == 0 || // Cart review always enabled
        (_step == 1 && _deliveryFormValid) ||
        (_step == 2 && _paymentFormValid) ||
        _step == 3; // Confirmation always enabled

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Colors.teal, width: 5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SizedBox(
        width: _isOrderCompleted ? 400 : 700,
        height: _isOrderCompleted ? 300 : null,
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(32),
              child:
                  _isOrderCompleted
                      ? const SuccessStep()
                      : Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          StepProgressBar(
                            currentStep: _step,
                            totalSteps: totalSteps,
                          ),
                          const SizedBox(height: 24),
                          steps[_step],
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
                                      foregroundColor:
                                          AppTheme.colorScheme.onPrimary,
                                    ),
                                    child: const ScalableText("Tillbaka"),
                                  ),
                              ElevatedButton(
                                onPressed:
                                    isNextEnabled
                                        ? _nextStep
                                        : null, // Disable if not valid
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                  foregroundColor:
                                      AppTheme.colorScheme.onPrimary,
                                  disabledBackgroundColor: Colors.grey,
                                ),
                                child: ScalableText(
                                  _step == totalSteps - 1 ? "Slutför" : "Nästa",
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
            ),
            if (_isOrderCompleted)
              Positioned(
                bottom: 8,
                left: 8,
                child: CloseButtonWidget(
                  onPressed: () => Navigator.pop(context),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
