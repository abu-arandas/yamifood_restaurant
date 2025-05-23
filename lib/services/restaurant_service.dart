import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/restaurant_model.dart';

class RestaurantService extends GetxService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'restaurants';

  Future<RestaurantModel> getRestaurant(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) {
        throw Exception('Restaurant not found');
      }
      return RestaurantModel.fromFirestore(doc);
    } catch (e) {
      Get.snackbar('Error', 'Failed to get restaurant: $e', snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<List<RestaurantModel>> getRestaurants() async {
    try {
      final snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.map((doc) => RestaurantModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get restaurants: $e', snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<List<RestaurantModel>> getRestaurantsByCuisine(String cuisine) async {
    try {
      final snapshot = await _firestore.collection(_collection).where('cuisine', isEqualTo: cuisine).get();

      return snapshot.docs.map((doc) => RestaurantModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get restaurants by cuisine: $e', snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<List<RestaurantModel>> getOpenRestaurants() async {
    try {
      final snapshot = await _firestore.collection(_collection).where('isOpen', isEqualTo: true).get();

      return snapshot.docs.map((doc) => RestaurantModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to get open restaurants: $e', snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<void> createRestaurant(RestaurantModel restaurant) async {
    try {
      await _firestore.collection(_collection).add(restaurant.toFirestore());
    } catch (e) {
      Get.snackbar('Error', 'Failed to create restaurant: $e', snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<void> updateRestaurant(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc(id).update(data);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update restaurant: $e', snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Future<void> deleteRestaurant(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete restaurant: $e', snackPosition: SnackPosition.BOTTOM);
      rethrow;
    }
  }

  Stream<List<RestaurantModel>> streamRestaurants() {
    return _firestore
        .collection(_collection)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => RestaurantModel.fromFirestore(doc)).toList());
  }

  Stream<List<RestaurantModel>> streamOpenRestaurants() {
    return _firestore
        .collection(_collection)
        .where('isOpen', isEqualTo: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => RestaurantModel.fromFirestore(doc)).toList());
  }
}
