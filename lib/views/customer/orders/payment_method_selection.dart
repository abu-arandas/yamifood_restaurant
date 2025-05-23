import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/payment_controller.dart';
import '../../../models/payment_method.dart';
import 'add_payment_method_view.dart';

class PaymentMethodSelection extends StatelessWidget {
  final _controller = Get.find<PaymentController>();

  PaymentMethodSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Payment Method',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Obx(() {
          if (_controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_controller.paymentMethods.isEmpty) {
            return Column(
              children: [
                const Text('No payment methods found'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () async {
                    await Get.to(() => AddPaymentMethodView());
                    _controller.getCustomerPayments();
                  },
                  child: const Text('Add Payment Method'),
                ),
              ],
            );
          }

          return Column(
            children: [
              ..._controller.paymentMethods.map((method) {
                final isSelected = _controller.selectedPaymentMethod.value?.id == method.id;
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: Icon(
                      _getPaymentTypeIcon(method.type),
                      color: isSelected ? Theme.of(context).primaryColor : null,
                    ),
                    title: Text(
                      '${method.type} ending in ${method.lastFourDigits}',
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : null,
                      ),
                    ),
                    subtitle: Text(method.cardholderName),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isSelected)
                          Icon(
                            Icons.check_circle,
                            color: Theme.of(context).primaryColor,
                          ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () => _showDeleteConfirmation(method),
                        ),
                      ],
                    ),
                    onTap: () => _controller.selectPaymentMethod(method),
                  ),
                );
              }).toList(),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () async {
                  await Get.to(() => AddPaymentMethodView());
                  _controller.getCustomerPayments();
                },
                icon: const Icon(Icons.add),
                label: const Text('Add Payment Method'),
              ),
            ],
          );
        }),
      ],
    );
  }

  IconData _getPaymentTypeIcon(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.cash:
        return Icons.money;
      case PaymentMethodType.creditCard:
      case PaymentMethodType.debitCard:
        return Icons.credit_card;
      case PaymentMethodType.paypal:
        return Icons.payment;
      case PaymentMethodType.applePay:
        return Icons.apple;
      case PaymentMethodType.googlePay:
        return Icons.g_mobiledata;
    }
  }

  void _showDeleteConfirmation(PaymentMethod method) {
    Get.dialog(
      AlertDialog(
        title: const Text('Delete Payment Method'),
        content: Text(
          'Are you sure you want to delete the payment method ending in ${method.lastFourDigits}?',
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              _controller.deletePayment(method.id);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
