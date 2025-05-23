import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/menu_item_model.dart';
import 'package:flutter/material.dart';

class MenuItemController extends GetxController {
  final CollectionReference _menuItemsRef = FirebaseFirestore.instance.collection('menu_items');

  final RxList<MenuItemModel> menuItems = <MenuItemModel>[].obs;
  final Rxn<MenuItemModel> selectedMenuItem = Rxn<MenuItemModel>();
  final RxBool isLoading = false.obs;
  final RxString lastError = ''.obs;
  final RxMap<String, List<MenuItemModel>> _cachedMenuItems = <String, List<MenuItemModel>>{}.obs;
  final RxBool _isCacheValid = false.obs;

  String get errorMessage => lastError.value;

  @override
  void onInit() {
    super.onInit();
    _initializeCache();
  }

  Future<void> _initializeCache() async {
    try {
      final restaurants = await _menuItemsRef.get();
      for (var doc in restaurants.docs) {
        final item = MenuItemModel.fromFirestore(doc);
        if (!_cachedMenuItems.containsKey(item.restaurantId)) {
          _cachedMenuItems[item.restaurantId] = [];
        }
        _cachedMenuItems[item.restaurantId]!.add(item);
      }
      _isCacheValid.value = true;
    } catch (e) {
      lastError.value = e.toString();
      _isCacheValid.value = false;
    }
  }

  Future<void> fetchMenuItems(String restaurantId) async {
    try {
      isLoading.value = true;
      lastError.value = '';

      // Return cached data if valid
      if (_isCacheValid.value && _cachedMenuItems.containsKey(restaurantId)) {
        menuItems.value = _cachedMenuItems[restaurantId]!;
        return;
      }

      final query = await _menuItemsRef
          .where('restaurantId', isEqualTo: restaurantId)
          .where('isAvailable', isEqualTo: true)
          .orderBy('name')
          .get();

      final items = query.docs.map((doc) => MenuItemModel.fromFirestore(doc)).toList();
      menuItems.value = items;
      _cachedMenuItems[restaurantId] = items;
      _isCacheValid.value = true;
    } catch (e) {
      lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to fetch menu items: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMenuItemById(String id) async {
    try {
      isLoading.value = true;
      lastError.value = '';
      final doc = await _menuItemsRef.doc(id).get();
      if (doc.exists) {
        selectedMenuItem.value = MenuItemModel.fromFirestore(doc);
      } else {
        selectedMenuItem.value = null;
        Get.snackbar(
          'Not Found',
          'Menu item not found',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to fetch menu item: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> createMenuItem(MenuItemModel item) async {
    try {
      isLoading.value = true;
      lastError.value = '';

      // Validate menu item data
      if (!item.isValid) {
        throw 'Invalid menu item data';
      }

      await _menuItemsRef.doc(item.id).set(item.toFirestore());
      await fetchMenuItems(item.restaurantId);
      _invalidateCache(item.restaurantId);

      Get.snackbar(
        'Success',
        'Menu item created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to create menu item: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateMenuItem(MenuItemModel item) async {
    try {
      isLoading.value = true;
      lastError.value = '';

      // Validate menu item data
      if (!item.isValid) {
        throw 'Invalid menu item data';
      }

      await _menuItemsRef.doc(item.id).update(item.toFirestore());
      await fetchMenuItems(item.restaurantId);
      _invalidateCache(item.restaurantId);

      Get.snackbar(
        'Success',
        'Menu item updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to update menu item: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteMenuItem(String id, String restaurantId) async {
    try {
      isLoading.value = true;
      lastError.value = '';
      await _menuItemsRef.doc(id).delete();
      await fetchMenuItems(restaurantId);
      _invalidateCache(restaurantId);

      Get.snackbar(
        'Success',
        'Menu item deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to delete menu item: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Stream<List<MenuItemModel>> streamMenuItems(String restaurantId) {
    return _menuItemsRef
        .where('restaurantId', isEqualTo: restaurantId)
        .where('isAvailable', isEqualTo: true)
        .orderBy('name')
        .snapshots()
        .map((snapshot) {
      final items = snapshot.docs.map((doc) => MenuItemModel.fromFirestore(doc)).toList();
      _cachedMenuItems[restaurantId] = items;
      return items;
    });
  }

  Future<MenuItemModel> createNewMenuItem({
    required String name,
    required String description,
    required double price,
    required List<String> categories,
    String? imageUrl,
    required Map<String, dynamic> nutritionalInfo,
    required List<String> ingredients,
    required String restaurantId,
    List<MenuItemOption>? options,
    List<String>? allergens,
    int? preparationTime,
    bool isSpicy = false,
    bool isVegetarian = false,
    bool isVegan = false,
  }) async {
    try {
      isLoading.value = true;
      lastError.value = '';

      final docRef = _menuItemsRef.doc();
      final item = MenuItemModel(
        id: docRef.id,
        restaurantId: restaurantId,
        name: name,
        description: description,
        price: price,
        categories: categories,
        imageUrl: imageUrl ?? '',
        nutritionalInfo: nutritionalInfo,
        ingredients: ingredients,
        isAvailable: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        options: options,
        allergens: allergens,
        preparationTime: preparationTime,
        isSpicy: isSpicy,
        isVegetarian: isVegetarian,
        isVegan: isVegan,
      );

      // Validate menu item data
      if (!item.isValid) {
        throw 'Invalid menu item data';
      }

      await docRef.set(item.toFirestore());
      await fetchMenuItems(restaurantId);
      _invalidateCache(restaurantId);

      Get.snackbar(
        'Success',
        'Menu item created successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      return item;
    } catch (e) {
      lastError.value = e.toString();
      Get.snackbar(
        'Error',
        'Failed to create menu item: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  void _invalidateCache(String restaurantId) {
    _cachedMenuItems.remove(restaurantId);
    _isCacheValid.value = false;
  }

  void invalidateAllCache() {
    _cachedMenuItems.clear();
    _isCacheValid.value = false;
  }
}
