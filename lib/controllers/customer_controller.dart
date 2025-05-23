import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/restaurant_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomerController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final RxList<RestaurantModel> restaurants = <RestaurantModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString lastError = ''.obs;
  final RxBool isLoggedIn = false.obs;
  final RxMap<String, dynamic> preferences = <String, dynamic>{}.obs;

  // Profile
  final RxString name = ''.obs;
  final RxString email = ''.obs;
  final RxString profileImage = ''.obs;
  final RxBool pushNotificationsEnabled = true.obs;
  final RxBool emailNotificationsEnabled = true.obs;

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final stateController = TextEditingController();
  final zipCodeController = TextEditingController();

  final Rx<UserModel?> user = Rx<UserModel?>(null);

  // User preferences keys
  static const String _prefLastLocation = 'last_location';
  static const String _prefFavoriteCuisines = 'favorite_cuisines';
  static const String _prefMaxDeliveryDistance = 'max_delivery_distance';
  static const String _prefMinRating = 'min_rating';
  static const String _prefMaxDeliveryTime = 'max_delivery_time';

  @override
  void onInit() {
    super.onInit();
    _initializeUser();
    _loadPreferences();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    super.onClose();
  }

  Future<void> _initializeUser() async {
    try {
      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        await _fetchUserData(currentUser.uid);
        isLoggedIn.value = true;
      }
    } catch (e) {
      lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to initialize user: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _loadPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      preferences.value = {
        _prefLastLocation: prefs.getString(_prefLastLocation),
        _prefFavoriteCuisines: prefs.getStringList(_prefFavoriteCuisines) ?? [],
        _prefMaxDeliveryDistance: prefs.getDouble(_prefMaxDeliveryDistance) ?? 10.0,
        _prefMinRating: prefs.getDouble(_prefMinRating) ?? 0.0,
        _prefMaxDeliveryTime: prefs.getInt(_prefMaxDeliveryTime) ?? 60,
      };
    } catch (e) {
      lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to load preferences: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _savePreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefLastLocation, preferences[_prefLastLocation] ?? '');
      await prefs.setStringList(_prefFavoriteCuisines, preferences[_prefFavoriteCuisines] ?? []);
      await prefs.setDouble(_prefMaxDeliveryDistance, preferences[_prefMaxDeliveryDistance] ?? 10.0);
      await prefs.setDouble(_prefMinRating, preferences[_prefMinRating] ?? 0.0);
      await prefs.setInt(_prefMaxDeliveryTime, preferences[_prefMaxDeliveryTime] ?? 60);
    } catch (e) {
      lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to save preferences: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> _fetchUserData(String uid) async {
    try {
      isLoading.value = true;
      lastError.value = '';
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        user.value = UserModel.fromFirestore(doc);
      } else {
        throw 'User data not found';
      }
    } catch (e) {
      lastError.value = e.toString();
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      isLoading.value = true;
      lastError.value = '';
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _fetchUserData(userCredential.user!.uid);
      isLoggedIn.value = true;
      Get.offAllNamed('/customer/home');
    } catch (e) {
      lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to sign in: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp(String email, String password, String name) async {
    try {
      isLoading.value = true;
      lastError.value = '';
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final newUser = UserModel(
        id: userCredential.user!.uid,
        email: email,
        name: name,
        userRole: UserRole.customer,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await _firestore.collection('users').doc(newUser.id).set(newUser.toMap());
      user.value = newUser;
      isLoggedIn.value = true;
      Get.offAllNamed('/customer/home');
    } catch (e) {
      lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to sign up: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      isLoading.value = true;
      lastError.value = '';
      await _auth.signOut();
      user.value = null;
      isLoggedIn.value = false;
      Get.offAllNamed('/login');
    } catch (e) {
      lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to sign out: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchRestaurants() async {
    try {
      isLoading.value = true;
      lastError.value = '';
      final snapshot = await _firestore.collection('restaurants').get();
      restaurants.value = snapshot.docs.map((doc) => RestaurantModel.fromFirestore(doc)).toList();
      _filterRestaurants();
    } catch (e) {
      lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to fetch restaurants: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void _filterRestaurants() {
    final filteredRestaurants = restaurants.where((restaurant) {
      // Filter by minimum rating
      if (restaurant.rating < (preferences[_prefMinRating] as double)) {
        return false;
      }

      // Filter by maximum delivery time
      if (restaurant.estimatedDeliveryTime > (preferences[_prefMaxDeliveryTime] as int)) {
        return false;
      }

      // Filter by favorite cuisines if any are set
      final favoriteCuisines = preferences[_prefFavoriteCuisines] as List<String>;
      if (favoriteCuisines.isNotEmpty && !favoriteCuisines.contains(restaurant.cuisine)) {
        return false;
      }

      return true;
    }).toList();

    restaurants.value = filteredRestaurants;
  }

  void updatePreferences(Map<String, dynamic> newPreferences) {
    preferences.addAll(newPreferences);
    _savePreferences();
    _filterRestaurants();
  }

  void viewRestaurant(RestaurantModel restaurant) {
    try {
      Get.toNamed('/customer/restaurant/${restaurant.id}');
    } catch (e) {
      lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to view restaurant details: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> updateUserProfile(UserModel updatedUser) async {
    try {
      isLoading.value = true;
      lastError.value = '';
      await _firestore.collection('users').doc(updatedUser.id).update(updatedUser.toMap());
      user.value = updatedUser;
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void togglePushNotifications(bool value) {
    pushNotificationsEnabled.value = value;
    _savePreferences();
  }

  void toggleEmailNotifications(bool value) {
    emailNotificationsEnabled.value = value;
    _savePreferences();
  }

  Future<void> updateProfile() async {
    try {
      isLoading.value = true;
      final updatedUser = user.value!.copyWith(
        name: nameController.text,
        phoneNumber: phoneController.text,
        additionalData: {
          'address': addressController.text,
          'city': cityController.text,
          'state': stateController.text,
          'zipCode': zipCodeController.text,
        },
        updatedAt: DateTime.now(),
      );
      await updateUserProfile(updatedUser);
    } finally {
      isLoading.value = false;
    }
  }
}
