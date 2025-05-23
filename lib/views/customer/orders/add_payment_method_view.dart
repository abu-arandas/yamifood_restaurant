import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/payment_controller.dart';
import '../../../models/payment_method.dart';

class AddPaymentMethodView extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _controller = Get.find<PaymentController>();

  AddPaymentMethodView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Payment Method'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _controller.cardNumberController,
                decoration: const InputDecoration(
                  labelText: 'Card Number',
                  hintText: '1234 5678 9012 3456',
                ),
                keyboardType: TextInputType.number,
                maxLength: 19, // Including spaces
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter card number';
                  }
                  // Remove spaces and check if it's a valid number
                  final number = value.replaceAll(' ', '');
                  if (number.length != 16 || !RegExp(r'^\d+$').hasMatch(number)) {
                    return 'Please enter a valid 16-digit card number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _controller.expiryController,
                      decoration: const InputDecoration(
                        labelText: 'Expiry Date',
                        hintText: 'MM/YY',
                      ),
                      maxLength: 5,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter expiry date';
                        }
                        if (!RegExp(r'^\d{2}/\d{2}$').hasMatch(value)) {
                          return 'Please enter in MM/YY format';
                        }
                        final parts = value.split('/');
                        final month = int.parse(parts[0]);
                        if (month < 1 || month > 12) {
                          return 'Invalid month';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _controller.cvvController,
                      decoration: const InputDecoration(
                        labelText: 'CVV',
                        hintText: '123',
                      ),
                      keyboardType: TextInputType.number,
                      maxLength: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter CVV';
                        }
                        if (!RegExp(r'^\d{3}$').hasMatch(value)) {
                          return 'Please enter a valid 3-digit CVV';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _controller.cardholderNameController,
                decoration: const InputDecoration(
                  labelText: 'Cardholder Name',
                  hintText: 'John Doe',
                ),
                textCapitalization: TextCapitalization.words,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter cardholder name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final cardNumber = _controller.cardNumberController.text.replaceAll(' ', '');
                    final expiryParts = _controller.expiryController.text.split('/');
                    await _controller.addPaymentMethod(
                      type: PaymentMethodType.creditCard,
                      lastFourDigits: cardNumber.substring(cardNumber.length - 4),
                      cardholderName: _controller.cardholderNameController.text,
                      expiryMonth: expiryParts[0],
                      expiryYear: '20${expiryParts[1]}',
                    );
                    Get.back();
                  }
                },
                child: const Text('Add Payment Method'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
