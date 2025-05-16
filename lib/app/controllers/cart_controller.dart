import '../../exports.dart';

class CartController extends GetxController {
  static CartController get to => Get.find();

  final cartItems = CartModel.empty().obs;

  double get subtotal => cartItems.value.totalPrice;

  double get tax => subtotal * 0.1; // 10% tax

  double get deliveryFee => 3.99;

  double get total => subtotal + tax + deliveryFee;

  int get itemCount => cartItems.value.totalItems;

  bool get isEmpty => cartItems.value.isEmpty;

  void addToCart(FoodModel food, int quantity, {String? specialInstructions}) {
    final cartItem = CartItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      food: food,
      quantity: quantity,
      specialInstructions: specialInstructions,
      addedAt: DateTime.now(),
    );

    cartItems.update((cart) {
      cart = cart!.addItem(cartItem);
    });

    Get.snackbar(
      'Added to Cart',
      '${food.name} has been added to your cart',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 2),
    );
  }

  void removeFromCart(String itemId) {
    cartItems.update((cart) {
      cart = cart!.removeItem(itemId);
    });
  }

  void updateItemQuantity(String itemId, int quantity) {
    if (quantity < 1) {
      removeFromCart(itemId);
      return;
    }

    cartItems.update((cart) {
      cart = cart!.updateItemQuantity(itemId, quantity);
    });
  }

  void clearCart() {
    cartItems.update((cart) {
      cart = cart!.clear();
    });
  }

  void incrementItemQuantity(String itemId) {
    final item = cartItems.value.items.firstWhere((item) => item.id == itemId);
    updateItemQuantity(itemId, item.quantity + 1);
  }

  void decrementItemQuantity(String itemId) {
    final item = cartItems.value.items.firstWhere((item) => item.id == itemId);
    updateItemQuantity(itemId, item.quantity - 1);
  }
}
