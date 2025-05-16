import '../../exports.dart';

class OrderController extends GetxController {
  static OrderController get to => Get.find();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthController _authController = Get.find<AuthController>();
  final CartController _cartController = Get.find<CartController>();

  RxList<OrderModel> userOrders = <OrderModel>[].obs;
  Rx<OrderModel?> currentOrder = Rx<OrderModel?>(null);

  RxBool isLoading = false.obs;
  RxString error = ''.obs;
  @override
  void onInit() {
    super.onInit();
    if (_authController.isLoggedIn) {
      fetchUserOrders();
    }

    // Listen to authentication changes
    ever(_authController.firebaseUser.obs, (user) {
      if (user != null) {
        fetchUserOrders();
      } else {
        userOrders.clear();
      }
    });
  }

  Future<void> fetchUserOrders() async {
    if (_authController.user == null) return;

    isLoading.value = true;
    error.value = '';
    try {
      final querySnapshot = await _firestore
          .collection('orders')
          .where('user.id', isEqualTo: _authController.user!.id)
          .orderBy('createdAt', descending: true)
          .get();

      userOrders.value = querySnapshot.docs
          .map((doc) => OrderModel.fromJson({
                'id': doc.id,
                ...doc.data(),
              }))
          .toList();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> placeOrder({
    required String deliveryAddress,
    required String paymentMethod,
  }) async {
    if (_authController.user == null || _cartController.isEmpty) return;

    isLoading.value = true;
    error.value = '';
    try {
      final orderRef = _firestore.collection('orders').doc();

      final order = OrderModel.fromCart(
        id: orderRef.id,
        user: _authController.user!,
        cart: _cartController.cartItems.value,
        taxRate: 0.1, // 10% tax
        deliveryFee: _cartController.deliveryFee,
        deliveryAddress: deliveryAddress,
        paymentMethod: paymentMethod,
      );

      await orderRef.set(order.toJson());

      currentOrder.value = order;
      _cartController.clearCart();

      await fetchUserOrders();

      Get.offNamed(Routes.HOME);
      Get.snackbar(
        'Order Placed',
        'Your order has been placed successfully!',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to place order: ${error.value}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> cancelOrder(String orderId) async {
    isLoading.value = true;
    error.value = '';
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': OrderStatus.cancelled.name,
        'updatedAt': Timestamp.fromDate(DateTime.now()),
      });

      await fetchUserOrders();

      Get.snackbar(
        'Order Cancelled',
        'Your order has been cancelled',
        snackPosition: SnackPosition.TOP,
        duration: const Duration(seconds: 3),
      );
    } catch (e) {
      error.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to cancel order: ${error.value}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }
}
