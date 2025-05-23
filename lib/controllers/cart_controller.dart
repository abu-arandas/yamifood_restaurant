import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/cart_model.dart';
import '../models/cart_item_model.dart';

class CartController extends GetxController {
  final CollectionReference _cartsRef = FirebaseFirestore.instance.collection('carts');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Rx<CartModel?> cart = Rx<CartModel?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadCart();
  }

  Future<void> loadCart() async {
    try {
      isLoading.value = true;
      final userId = _auth.currentUser?.uid;
      if (userId != null) {
        final query = await _cartsRef.where('customerId', isEqualTo: userId).limit(1).get();
        if (query.docs.isNotEmpty) {
          cart.value = CartModel.fromFirestore(query.docs.first);
        }
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load cart: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> addToCart(CartItemModel item) async {
    try {
      isLoading.value = true;
      if (cart.value == null) {
        final userId = _auth.currentUser?.uid;
        if (userId != null) {
          cart.value = CartModel(
            id: 'cart_${DateTime.now().millisecondsSinceEpoch}',
            customerId: userId,
            restaurantId: item.restaurantId,
            restaurantName: item.restaurantName,
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
      }
      if (cart.value != null) {
        final updatedItems = List<CartItemModel>.from(cart.value!.items);
        final index = updatedItems.indexWhere((i) => i.id == item.id);
        if (index >= 0) {
          final existingItem = updatedItems[index];
          updatedItems[index] = CartItemModel(
            id: existingItem.id,
            name: existingItem.name,
            imageUrl: existingItem.imageUrl,
            price: existingItem.price,
            quantity: existingItem.quantity + item.quantity,
            restaurantId: existingItem.restaurantId,
            restaurantName: existingItem.restaurantName,
            options: existingItem.options,
            specialInstructions: existingItem.specialInstructions,
          );
        } else {
          updatedItems.add(item);
        }
        final subtotal = updatedItems.fold<double>(0, (total, item) => total + item.total);
        final updatedCart = cart.value!.copyWith(
          items: updatedItems,
          subtotal: subtotal,
          total: subtotal + cart.value!.deliveryFee + cart.value!.tax,
          updatedAt: DateTime.now(),
        );
        await _updateCart(updatedCart);
        await loadCart();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to add item to cart: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> removeFromCart(String menuItemId) async {
    try {
      isLoading.value = true;
      if (cart.value != null) {
        final updatedItems = cart.value!.items.where((i) => i.id != menuItemId).toList();
        final subtotal = updatedItems.fold<double>(0, (total, item) => total + item.total);
        final updatedCart = cart.value!.copyWith(
          items: updatedItems,
          subtotal: subtotal,
          total: subtotal + cart.value!.deliveryFee + cart.value!.tax,
          updatedAt: DateTime.now(),
        );
        await _updateCart(updatedCart);
        await loadCart();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove item from cart: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> clearCart() async {
    try {
      isLoading.value = true;
      if (cart.value != null) {
        final updatedCart = cart.value!.copyWith(
          items: [],
          subtotal: 0,
          total: 0,
          updatedAt: DateTime.now(),
        );
        await _updateCart(updatedCart);
        await loadCart();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to clear cart: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateDeliveryAddress(Map<String, LatLng> address) async {
    try {
      isLoading.value = true;
      if (cart.value != null) {
        final updatedCart = cart.value!.copyWith(deliveryAddress: address);
        await _updateCart(updatedCart);
        await loadCart();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update delivery address: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> applyPromoCode(String code) async {
    try {
      isLoading.value = true;
      if (cart.value != null) {
        final updatedCart = cart.value!.copyWith(promoCode: code);
        await _updateCart(updatedCart);
        await loadCart();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to apply promo code: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> checkout() async {
    try {
      isLoading.value = true;
      if (cart.value != null) {
        final updatedCart = cart.value!.copyWith(status: CartStatus.checkingOut);
        await _updateCart(updatedCart);
        Get.toNamed('/checkout', arguments: cart.value);
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to proceed to checkout: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _updateCart(CartModel cart) async {
    await _cartsRef.doc(cart.id).set(cart.toFirestore());
  }
}
