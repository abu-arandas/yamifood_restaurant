import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../../../controllers/address_controller.dart';
import '../../../controllers/payment_controller.dart';
import '../../../models/cart_model.dart';
import '../../../models/order_model.dart';
import '../../../services/auth_service.dart';
import '../../../services/order_service.dart';
import '../../../services/restaurant_service.dart';
import 'address_selection.dart';
import 'payment_method_selection.dart';
import 'order_summary.dart';

class CheckoutController extends GetxController {
  final RxBool isPlacingOrder = false.obs;
  final RxString errorMessage = ''.obs;
  final AddressController addressController = Get.put(AddressController());
  final PaymentController paymentController = Get.put(PaymentController());
  final OrderService orderService = Get.find<OrderService>();
  final RestaurantService restaurantService = Get.find<RestaurantService>();
  final AuthService authService = Get.find<AuthService>();

  Future<LatLng> _getLatLngFromAddress(String address) async {
    try {
      final locations = await locationFromAddress(address);
      if (locations.isNotEmpty) {
        return LatLng(locations.first.latitude, locations.first.longitude);
      }
      throw Exception('No location found for the address');
    } catch (e) {
      throw Exception('Failed to geocode address: ${e.toString()}');
    }
  }

  Future<void> placeOrder(CartModel cart) async {
    if (addressController.selectedAddress.value == null) {
      errorMessage.value = 'Please select a delivery address';
      return;
    }

    if (paymentController.selectedPaymentMethod.value == null) {
      errorMessage.value = 'Please select a payment method';
      return;
    }

    try {
      isPlacingOrder.value = true;
      errorMessage.value = '';

      final paymentMethod = paymentController.selectedPaymentMethod.value!;
      final address = addressController.selectedAddress.value!;

      // Convert address to LatLng using geocoding
      final deliveryAddress = await _getLatLngFromAddress(address.toString());

      // Get restaurant location
      final restaurant = await restaurantService.getRestaurant(cart.restaurantId);
      final restaurantLocation = restaurant.location;

      final order = OrderModel(
        id: '',
        customerId: authService.currentUser.value?.uid ?? '',
        restaurantId: cart.restaurantId,
        items: cart.items
            .map((item) => OrderItem(
                  id: item.id,
                  name: item.name,
                  price: item.price,
                  quantity: item.quantity,
                  notes: item.specialInstructions,
                ))
            .toList(),
        totalAmount: cart.total,
        status: OrderStatus.pending,
        paymentMethod: paymentMethod.toFirestore().toString(),
        paymentStatus: 'pending',
        deliveryAddress: deliveryAddress,
        createdAt: DateTime.now(),
        restaurantName: cart.restaurantName,
        restaurantLocation: restaurantLocation,
      );

      await orderService.createOrder(order);
      Get.offAllNamed('/orders'); // Navigate to orders list
    } catch (e) {
      errorMessage.value = 'Failed to place order: ${e.toString()}';
    } finally {
      isPlacingOrder.value = false;
    }
  }
}

class CheckoutView extends StatelessWidget {
  final CartModel cart;
  final CheckoutController _controller = Get.put(CheckoutController());

  CheckoutView({Key? key, required this.cart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      body: Obx(() {
        if (_controller.addressController.isLoading.value || _controller.paymentController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                title: 'Delivery Address',
                child: AddressSelection(
                  addresses: _controller.addressController.addresses,
                  selectedAddress: _controller.addressController.selectedAddress.value,
                  onAddressSelected: (address) {
                    _controller.addressController.selectAddress(address);
                  },
                ),
              ),
              _buildSection(
                title: 'Payment Method',
                child: PaymentMethodSelection(),
              ),
              _buildSection(
                title: 'Order Summary',
                child: OrderSummary(cart: cart),
              ),
              const SizedBox(height: 24),
              Obx(() {
                if (_controller.errorMessage.isNotEmpty) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      _controller.errorMessage.value,
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _controller.isPlacingOrder.value ? null : () => _controller.placeOrder(cart),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _controller.isPlacingOrder.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Place Order',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
