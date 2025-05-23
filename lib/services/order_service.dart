import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/order_model.dart';

class OrderService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'orders';

  Future<void> createOrder(OrderModel order) async {
    try {
      await _firestore.collection(_collection).add(order.toFirestore());
    } catch (e) {
      Get.snackbar('Error', 'Failed to create order: $e', snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<OrderModel> getOrder(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) {
        throw Exception('Order not found');
      }
      return OrderModel.fromFirestore(doc);
    } catch (e) {
      Get.snackbar('Error', 'Failed to get order: $e', snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<List<OrderModel>> getCustomerOrders(String customerId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('customerId', isEqualTo: customerId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get customer orders: $e', snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<List<OrderModel>> getRestaurantOrders(String restaurantId) async {
    try {
      final snapshot = await _firestore
          .collection(_collection)
          .where('restaurantId', isEqualTo: restaurantId)
          .orderBy('createdAt', descending: true)
          .get();

      return snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get restaurant orders: $e', snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<void> updateOrder(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc(id).update(data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update order: $e', snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<void> deleteOrder(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete order: $e', snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Stream<List<OrderModel>> streamCustomerOrders(String customerId) {
    return _firestore
        .collection(_collection)
        .where('customerId', isEqualTo: customerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList());
  }

  Stream<List<OrderModel>> streamRestaurantOrders(String restaurantId) {
    return _firestore
        .collection(_collection)
        .where('restaurantId', isEqualTo: restaurantId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList());
  }
}
