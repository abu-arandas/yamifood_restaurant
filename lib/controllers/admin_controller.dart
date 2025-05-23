import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/restaurant_model.dart';
import '../models/order_model.dart';
import '../models/menu_item_model.dart';

class AdminController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final RxList<UserModel> users = <UserModel>[].obs;
  final RxList<RestaurantModel> restaurants = <RestaurantModel>[].obs;
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxBool isLoading = false.obs;

  // Stats
  final totalOrders = 0.obs;
  final totalRevenue = 0.0.obs;
  final activeOrders = 0.obs;
  final averageOrder = 0.0.obs;

  // Orders
  final recentOrders = <OrderModel>[].obs;

  // Menu Items
  final menuItems = <MenuItemModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
    loadRestaurants();
    loadOrders();
    loadDashboardData();
  }

  Future<void> loadUsers() async {
    try {
      isLoading.value = true;
      final QuerySnapshot snapshot = await _firestore.collection('users').get();
      users.value = snapshot.docs.map((doc) => UserModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load users: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadRestaurants() async {
    try {
      isLoading.value = true;
      final QuerySnapshot snapshot = await _firestore.collection('restaurants').get();
      restaurants.value = snapshot.docs.map((doc) => RestaurantModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load restaurants: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      final QuerySnapshot snapshot = await _firestore.collection('orders').get();
      orders.value = snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load orders: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadDashboardData() async {
    try {
      isLoading.value = true;
      await Future.wait([
        loadStats(),
        loadRecentOrders(),
        loadMenuItems(),
      ]);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load dashboard data',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadStats() async {
    try {
      final today = DateTime.now().subtract(const Duration(hours: 24));
      final ordersSnapshot = await _firestore.collection('orders').where('createdAt', isGreaterThan: today).get();

      int totalOrders = 0;
      double totalRevenue = 0;
      int activeOrders = 0;

      for (var doc in ordersSnapshot.docs) {
        totalOrders++;
        totalRevenue += doc.data()['total'] ?? 0;
        if (doc.data()['status'] == 'active') {
          activeOrders++;
        }
      }

      this.totalOrders.value = totalOrders;
      this.totalRevenue.value = totalRevenue;
      this.activeOrders.value = activeOrders;
      averageOrder.value = totalOrders > 0 ? totalRevenue / totalOrders : 0;
    } catch (e) {
      Get.snackbar('Error', 'Failed to get stats: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to get stats: $e');
    }
  }

  Future<void> loadRecentOrders() async {
    try {
      final snapshot = await _firestore.collection('orders').orderBy('createdAt', descending: true).limit(10).get();

      final orders = snapshot.docs.map((doc) => OrderModel.fromJson(doc.data())).toList();
      recentOrders.assignAll(orders);
    } catch (e) {
      Get.snackbar('Error', 'Failed to get recent orders: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to get recent orders: $e');
    }
  }

  Future<void> loadMenuItems() async {
    try {
      final snapshot = await _firestore.collection('menu_items').get();
      final items = snapshot.docs.map((doc) => MenuItemModel.fromJson(doc.data())).toList();
      menuItems.assignAll(items);
    } catch (e) {
      Get.snackbar('Error', 'Failed to get menu items: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to get menu items: $e');
    }
  }

  void viewOrderDetails(OrderModel order) {
    Get.toNamed('/admin/orders/${order.id}');
  }

  void editMenuItem(MenuItemModel item) {
    Get.toNamed('/admin/menu/edit/${item.id}');
  }

  Future<void> createMenuItem(MenuItemModel item) async {
    try {
      await _firestore.collection('menu_items').doc(item.id).set(item.toJson());
      menuItems.add(item);
      Get.snackbar(
        'Success',
        'Menu item created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to create menu item: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to create menu item: $e');
    }
  }

  Future<void> updateMenuItem(MenuItemModel item) async {
    try {
      await _firestore.collection('menu_items').doc(item.id).update(item.toJson());
      final index = menuItems.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        menuItems[index] = item;
      }
      Get.snackbar(
        'Success',
        'Menu item updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to update menu item: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to update menu item: $e');
    }
  }

  Future<void> updateMenuItemAvailability(MenuItemModel item, bool isAvailable) async {
    try {
      final updatedItem = item.copyWith(isAvailable: isAvailable);
      await _firestore.collection('menu_items').doc(item.id).update(updatedItem.toJson());
      final index = menuItems.indexWhere((i) => i.id == item.id);
      if (index != -1) {
        menuItems[index] = updatedItem;
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update item availability',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> deleteMenuItem(String itemId) async {
    try {
      await _firestore.collection('menu_items').doc(itemId).delete();
      menuItems.removeWhere((item) => item.id == itemId);
      Get.snackbar(
        'Success',
        'Menu item deleted successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete menu item: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to delete menu item: $e');
    }
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      await _firestore.collection('orders').doc(orderId).update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      final index = recentOrders.indexWhere((order) => order.id == orderId);
      if (index != -1) {
        final order = recentOrders[index];
        recentOrders[index] = order.copyWith(status: status);
      }
      Get.snackbar(
        'Success',
        'Order status updated successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar('Error', 'Failed to update order status: $e', snackPosition: SnackPosition.BOTTOM);
      throw Exception('Failed to update order status: $e');
    }
  }

  Future<void> updateUserRole(String userId, UserRole role) async {
    try {
      isLoading.value = true;
      await _firestore.collection('users').doc(userId).update({
        'userRole': role.toString().split('.').last,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await loadUsers();
      Get.snackbar('Success', 'User role updated successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update user role: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateRestaurantStatus(String restaurantId, bool isActive) async {
    try {
      isLoading.value = true;
      await _firestore.collection('restaurants').doc(restaurantId).update({
        'isActive': isActive,
        'updatedAt': FieldValue.serverTimestamp(),
      });
      await loadRestaurants();
      Get.snackbar('Success', 'Restaurant status updated successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update restaurant status: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteUser(String userId) async {
    try {
      isLoading.value = true;
      await _firestore.collection('users').doc(userId).delete();
      await loadUsers();
      Get.snackbar('Success', 'User deleted successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete user: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteRestaurant(String restaurantId) async {
    try {
      isLoading.value = true;
      await _firestore.collection('restaurants').doc(restaurantId).delete();
      await loadRestaurants();
      Get.snackbar('Success', 'Restaurant deleted successfully', snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete restaurant: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      Get.offAllNamed('/login');
    } catch (e) {
      Get.snackbar('Error', 'Failed to sign out: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }
}
