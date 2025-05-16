import '../../../exports.dart';

class CheckoutView extends GetView<OrderController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.find<CartController>();
    final authController = Get.find<AuthController>();

    final addressController = TextEditingController(
      text: authController.user?.address ?? '',
    );

    final selectedPaymentMethod = 'Cash on Delivery'.obs;
    final paymentMethods = [
      'Cash on Delivery',
      'Credit Card',
      'PayPal',
    ];

    final formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Column(
        children: [
          // Checkout Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // User Info Section
                    const Text(
                      'Contact Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Obx(() => Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name: ${authController.user?.name}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Email: ${authController.user?.email}',
                              style: const TextStyle(fontSize: 16),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Phone: ${authController.user?.phoneNumber ?? 'Not provided'}',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ],
                        )),
                    const SizedBox(height: 24),

                    // Delivery Address
                    const Text(
                      'Delivery Address',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: addressController,
                      decoration: const InputDecoration(
                        hintText: 'Enter your delivery address',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your delivery address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),

                    // Payment Method
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...paymentMethods.map(
                      (method) => Obx(() => RadioListTile<String>(
                            title: Text(method),
                            value: method,
                            groupValue: selectedPaymentMethod.value,
                            onChanged: (value) {
                              if (value != null) {
                                selectedPaymentMethod.value = value;
                              }
                            },
                          )),
                    ),
                    const SizedBox(height: 24),

                    // Order Summary
                    const Text(
                      'Order Summary',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ...cartController.cartItems.value.items.map(
                      (item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Text(
                              '${item.quantity}x',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(item.food.name),
                            ),
                            Text(
                              Helpers.formatCurrency(item.totalPrice),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal'),
                        Text(
                          Helpers.formatCurrency(cartController.subtotal),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tax (10%)'),
                        Text(
                          Helpers.formatCurrency(cartController.tax),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Delivery Fee'),
                        Text(
                          Helpers.formatCurrency(cartController.deliveryFee),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        Text(
                          Helpers.formatCurrency(cartController.total),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Place Order Button
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              child: Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value
                        ? null
                        : () {
                            if (formKey.currentState!.validate()) {
                              controller.placeOrder(
                                deliveryAddress: addressController.text.trim(),
                                paymentMethod: selectedPaymentMethod.value,
                              );
                            }
                          },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: controller.isLoading.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text('PLACE ORDER'),
                    ),
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
