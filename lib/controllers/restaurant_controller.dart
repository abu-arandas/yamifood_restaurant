import 'package:get/get.dart';
import '../models/restaurant_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class RestaurantController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'restaurants';
  final Rx<RestaurantModel?> restaurant = Rx<RestaurantModel?>(null);
  final RxBool isLoading = false.obs;
  final RxList<RestaurantModel> _cachedRestaurants = <RestaurantModel>[].obs;
  final RxBool _isCacheValid = false.obs;
  final RxString _lastError = ''.obs;

  String get lastError => _lastError.value;

  @override
  void onInit() {
    super.onInit();
    _initializeCache();
  }

  Future<void> _initializeCache() async {
    try {
      final restaurants = await getRestaurants();
      _cachedRestaurants.value = restaurants;
      _isCacheValid.value = true;
    } catch (e) {
      _lastError.value = e.toString();
      _isCacheValid.value = false;
    }
  }

  Future<void> fetchRestaurant(String id) async {
    try {
      isLoading.value = true;
      _lastError.value = '';
      final restaurantData = await getRestaurant(id);
      restaurant.value = restaurantData;
    } catch (e) {
      _lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to fetch restaurant: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateRestaurant(RestaurantModel updatedRestaurant) async {
    try {
      isLoading.value = true;
      _lastError.value = '';

      // Validate restaurant data
      if (!updatedRestaurant.isValid) {
        throw 'Invalid restaurant data';
      }

      await updateRestaurantData(updatedRestaurant.id, updatedRestaurant.toFirestore());
      restaurant.value = updatedRestaurant;

      // Update cache if restaurant is in it
      final index = _cachedRestaurants.indexWhere((r) => r.id == updatedRestaurant.id);
      if (index != -1) {
        _cachedRestaurants[index] = updatedRestaurant;
      }

      Get.snackbar(
        'Success',
        'Restaurant updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      _lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to update restaurant: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<RestaurantModel>> fetchRestaurants() async {
    try {
      isLoading.value = true;
      _lastError.value = '';

      // Return cached data if valid
      if (_isCacheValid.value) {
        return _cachedRestaurants;
      }

      final restaurants = await getRestaurants();
      _cachedRestaurants.value = restaurants;
      _isCacheValid.value = true;
      return restaurants;
    } catch (e) {
      _lastError.value = e.toString();
      _isCacheValid.value = false;
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRestaurantById(String id) async {
    try {
      isLoading.value = true;
      _lastError.value = '';
      final selectedRestaurant = await getRestaurant(id);
      restaurant.value = selectedRestaurant;
    } catch (e) {
      _lastError.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createRestaurant(RestaurantModel restaurant) async {
    try {
      isLoading.value = true;
      _lastError.value = '';

      // Validate restaurant data
      if (!restaurant.isValid) {
        throw 'Invalid restaurant data';
      }

      await createRestaurantData(restaurant);
      await fetchRestaurants();
      _isCacheValid.value = false; // Invalidate cache
    } catch (e) {
      _lastError.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteRestaurant(String id) async {
    try {
      isLoading.value = true;
      _lastError.value = '';
      await deleteRestaurantData(id);
      await fetchRestaurants();
      _isCacheValid.value = false; // Invalidate cache
    } catch (e) {
      _lastError.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<List<RestaurantModel>> getRestaurants() async {
    try {
      final QuerySnapshot snapshot = await _firestore.collection(_collection).get();
      return snapshot.docs.map((doc) => RestaurantModel.fromFirestore(doc)).toList();
    } catch (e) {
      _lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to get restaurants: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      throw Exception('Failed to get restaurants: $e');
    }
  }

  Future<RestaurantModel> getRestaurant(String id) async {
    try {
      final DocumentSnapshot doc = await _firestore.collection(_collection).doc(id).get();
      if (!doc.exists) {
        throw Exception('Restaurant not found');
      }
      return RestaurantModel.fromFirestore(doc);
    } catch (e) {
      _lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to get restaurant: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      throw Exception('Failed to get restaurant: $e');
    }
  }

  Future<void> updateRestaurantData(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collection).doc(id).update(data);
    } catch (e) {
      _lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to update restaurant: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      throw Exception('Failed to update restaurant: $e');
    }
  }

  Future<void> createRestaurantData(RestaurantModel restaurant) async {
    try {
      await _firestore.collection(_collection).add(restaurant.toFirestore());
    } catch (e) {
      _lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to create restaurant: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      throw Exception('Failed to create restaurant: $e');
    }
  }

  Future<void> deleteRestaurantData(String id) async {
    try {
      await _firestore.collection(_collection).doc(id).delete();
    } catch (e) {
      _lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to delete restaurant: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      throw Exception('Failed to delete restaurant: $e');
    }
  }

  void invalidateCache() {
    _isCacheValid.value = false;
  }
}
