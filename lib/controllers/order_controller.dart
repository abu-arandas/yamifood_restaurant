import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/order_model.dart';

class OrderController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collection = 'orders';
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;

  Future<List<OrderModel>> getOrders() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get orders: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to get orders: $e');
    }
  }

  Future<OrderModel> getOrder(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) {
        throw Exception('Order not found');
      }
      return OrderModel.fromFirestore(doc);
    } catch (e) {
      Get.snackbar('Error', 'Failed to get order: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to get order: $e');
    }
  }

  Future<void> updateOrder(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc(id).update(data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update order: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to update order: $e');
    }
  }

  Future<void> deleteOrder(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete order: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to delete order: $e');
    }
  }

  Future<void> createOrder(OrderModel order) async {
    try {
      await _firestore.collection(_collection).add(order.toFirestore());
    } catch (e) {
      Get.snackbar('Error', 'Failed to create order: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to create order: $e');
    }
  }

  Future<void> fetchOrders() async {
    try {
      isLoading.value = true;
      final orderList = await getOrders();
      orders.value = orderList;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch orders: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchOrderById(String id) async {
    try {
      isLoading.value = true;
      final order = await getOrder(id);
      orders.value = [order];
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch order: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createNewOrder(OrderModel order) async {
    try {
      isLoading.value = true;
      await createOrder(order);
      await fetchOrders();
      Get.snackbar('Success', 'Order created successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to create order: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateExistingOrder(OrderModel order) async {
    try {
      isLoading.value = true;
      await updateOrder(order.id, order.toFirestore());
      await fetchOrders();
      Get.snackbar('Success', 'Order updated successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update order: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteExistingOrder(String id) async {
    try {
      isLoading.value = true;
      await deleteOrder(id);
      await fetchOrders();
      Get.snackbar('Success', 'Order deleted successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete order: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void viewOrderDetails(OrderModel order) {
    Get.toNamed('/order/${order.id}');
  }

  Future<void> cancelOrder(OrderModel order) async {
    try {
      isLoading.value = true;
      if (!order.canBeCancelled()) {
        throw Exception('Order cannot be cancelled in its current state');
      }
      await updateOrder(order.id, {
        'status': OrderStatus.cancelled.toString().split('.').last,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      await fetchOrders();
      Get.snackbar('Success', 'Order cancelled successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to cancel order: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      isLoading.value = true;
      await updateOrder(orderId, {
        'status': status.toString().split('.').last,
        'updatedAt': DateTime.now().toIso8601String(),
      });
      await fetchOrders();
      Get.snackbar('Success', 'Order status updated successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update order status: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<OrderModel>> getCustomerOrders() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) throw Exception('User not authenticated');

      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('customerId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get customer orders: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to get customer orders: $e');
    }
  }

  Future<List<OrderModel>> getRestaurantOrders() async {
    try {
      final restaurantId = _auth.currentUser?.uid;
      if (restaurantId == null) throw Exception('User not authenticated');

      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('restaurantId', isEqualTo: restaurantId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get restaurant orders: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to get restaurant orders: $e');
    }
  }

  Future<List<OrderModel>> getDriverOrders() async {
    try {
      final driverId = _auth.currentUser?.uid;
      if (driverId == null) throw Exception('User not authenticated');

      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('driverId', isEqualTo: driverId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get driver orders: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to get driver orders: $e');
    }
  }

  Stream<List<OrderModel>> streamCustomerOrders() {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('User not authenticated');

    return _firestore
        .collection(_collection)
        .where('customerId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList());
  }

  Stream<List<OrderModel>> streamRestaurantOrders() {
    final restaurantId = _auth.currentUser?.uid;
    if (restaurantId == null) throw Exception('User not authenticated');

    return _firestore
        .collection(_collection)
        .where('restaurantId', isEqualTo: restaurantId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList());
  }

  Stream<List<OrderModel>> streamDriverOrders() {
    final driverId = _auth.currentUser?.uid;
    if (driverId == null) throw Exception('User not authenticated');

    return _firestore
        .collection(_collection)
        .where('driverId', isEqualTo: driverId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList());
  }

  Future<void> fetchCustomerOrders() async {
    try {
      isLoading.value = true;
      final orderList = await getCustomerOrders();
      orders.value = orderList;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch customer orders: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRestaurantOrders() async {
    try {
      isLoading.value = true;
      final orderList = await getRestaurantOrders();
      orders.value = orderList;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch restaurant orders: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDriverOrders() async {
    try {
      isLoading.value = true;
      final orderList = await getDriverOrders();
      orders.value = orderList;
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch driver orders: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
