import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_item_model.dart';
import '../models/menu_item_model.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';
import '../controllers/order_controller.dart';

class POSController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final String _collection = 'orders';
  final RxList<OrderModel> orders = <OrderModel>[].obs;
  final RxList<MenuItemModel> menuItems = <MenuItemModel>[].obs;
  final RxBool isLoading = false.obs;
  final OrderController _orderController = Get.find<OrderController>();
  late final Rx<CartModel> currentOrder;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
    loadMenuItems();
    final restaurantId = _auth.currentUser?.uid ?? 'pos_user';
    currentOrder = Rx<CartModel>(CartModel(
      id: 'pos_${DateTime.now().millisecondsSinceEpoch}',
      customerId: 'pos_user',
      restaurantId: restaurantId,
      restaurantName: 'POS Terminal',
      items: [],
      subtotal: 0,
      deliveryFee: 0,
      tax: 0,
      total: 0,
      status: CartStatus.active,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
  }

  Future<void> loadOrders() async {
    try {
      isLoading.value = true;
      final restaurantId = _auth.currentUser?.uid ?? 'pos_user';
      final QuerySnapshot snapshot = await _firestore
          .collection(_collection)
          .where('restaurantId', isEqualTo: restaurantId)
          .orderBy('createdAt', descending: true)
          .get();

      orders.value = snapshot.docs.map((doc) => OrderModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load orders: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadMenuItems() async {
    try {
      isLoading.value = true;
      final restaurantId = _auth.currentUser?.uid ?? 'pos_user';
      final QuerySnapshot snapshot = await _firestore
          .collection('menu_items')
          .where('restaurantId', isEqualTo: restaurantId)
          .orderBy('name')
          .get();

      menuItems.value = snapshot.docs.map((doc) => MenuItemModel.fromFirestore(doc)).toList();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load menu items: $e', snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void addItemToOrder(MenuItemModel item) {
    final existingItem = currentOrder.value.items.firstWhere(
      (i) => i.id == item.id,
      orElse: () => CartItemModel(
        id: item.id,
        name: item.name,
        price: item.price,
        imageUrl: item.imageUrl,
        quantity: 0,
        restaurantId: currentOrder.value.restaurantId,
        restaurantName: currentOrder.value.restaurantName,
      ),
    );

    if (existingItem.quantity == 0) {
      currentOrder.value.items.add(
        CartItemModel(
          id: item.id,
          name: item.name,
          price: item.price,
          imageUrl: item.imageUrl,
          quantity: 1,
          restaurantId: currentOrder.value.restaurantId,
          restaurantName: currentOrder.value.restaurantName,
        ),
      );
    } else {
      incrementItem(existingItem);
    }
    _updateOrderTotals();
  }

  void incrementItem(CartItemModel item) {
    final index = currentOrder.value.items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      final updatedItem = CartItemModel(
        id: item.id,
        name: item.name,
        price: item.price,
        imageUrl: item.imageUrl,
        quantity: item.quantity + 1,
        restaurantId: item.restaurantId,
        restaurantName: item.restaurantName,
        options: item.options,
        specialInstructions: item.specialInstructions,
      );
      currentOrder.value.items[index] = updatedItem;
      currentOrder.refresh();
      _updateOrderTotals();
    }
  }

  void decrementItem(CartItemModel item) {
    final index = currentOrder.value.items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      if (item.quantity > 1) {
        final updatedItem = CartItemModel(
          id: item.id,
          name: item.name,
          price: item.price,
          imageUrl: item.imageUrl,
          quantity: item.quantity - 1,
          restaurantId: item.restaurantId,
          restaurantName: item.restaurantName,
          options: item.options,
          specialInstructions: item.specialInstructions,
        );
        currentOrder.value.items[index] = updatedItem;
      } else {
        removeItem(item);
      }
      currentOrder.refresh();
      _updateOrderTotals();
    }
  }

  void removeItem(CartItemModel item) {
    currentOrder.value.items.removeWhere((i) => i.id == item.id);
    currentOrder.refresh();
    _updateOrderTotals();
  }

  void clearOrder() {
    final restaurantId = _auth.currentUser?.uid ?? 'pos_user';
    currentOrder.value = CartModel(
      id: 'pos_${DateTime.now().millisecondsSinceEpoch}',
      customerId: 'pos_user',
      restaurantId: restaurantId,
      restaurantName: 'POS Terminal',
      items: [],
      subtotal: 0,
      deliveryFee: 0,
      tax: 0,
      total: 0,
      status: CartStatus.active,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  void _updateOrderTotals() {
    final subtotal = currentOrder.value.items.fold<double>(0, (total, item) => total + item.total);
    currentOrder.value = currentOrder.value.copyWith(
      subtotal: subtotal,
      total: subtotal + currentOrder.value.deliveryFee + currentOrder.value.tax,
      updatedAt: DateTime.now(),
    );
  }

  Future<void> checkout() async {
    if (currentOrder.value.items.isEmpty) {
      Get.snackbar(
        'Error',
        'Cannot checkout with an empty order',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      isLoading.value = true;
      final order = OrderModel(
        id: '', // Will be set by Firestore
        customerId: 'pos_user',
        restaurantId: currentOrder.value.restaurantId,
        items: currentOrder.value.items
            .map((item) => OrderItem(
                  id: item.id,
                  name: item.name,
                  price: item.price,
                  quantity: item.quantity,
                  notes: item.specialInstructions,
                ))
            .toList(),
        totalAmount: currentOrder.value.total,
        status: OrderStatus.pending,
        paymentMethod: 'cash',
        paymentStatus: '', // TODO
        deliveryAddress: currentOrder.value.deliveryAddress!.values.first,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        restaurantName: currentOrder.value.restaurantName,
        restaurantLocation: {'latitude': 0.0, 'longitude': 0.0}, // TODO: Get actual location
      );

      await _orderController.createOrder(order);
      clearOrder();
      Get.snackbar(
        'Success',
        'Order created successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to create order: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
