import '../../exports.dart';

class CartItemModel {
  final String id;
  final FoodModel food;
  final int quantity;
  final String? specialInstructions;
  final DateTime addedAt;

  CartItemModel({
    required this.id,
    required this.food,
    required this.quantity,
    this.specialInstructions,
    required this.addedAt,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      food: FoodModel.fromJson(json['food'] as Map<String, dynamic>),
      quantity: json['quantity'] as int,
      specialInstructions: json['specialInstructions'] as String?,
      addedAt: (json['addedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'food': food.toJson(),
      'quantity': quantity,
      'specialInstructions': specialInstructions,
      'addedAt': Timestamp.fromDate(addedAt),
    };
  }

  double get totalPrice => food.price * quantity;

  CartItemModel copyWith({
    String? id,
    FoodModel? food,
    int? quantity,
    String? specialInstructions,
    DateTime? addedAt,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      food: food ?? this.food,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      addedAt: addedAt ?? this.addedAt,
    );
  }
}

class CartModel {
  final List<CartItemModel> items;

  CartModel({
    required this.items,
  });

  factory CartModel.empty() => CartModel(items: []);

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      items: (json['items'] as List<dynamic>).map((e) => CartItemModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  double get totalPrice => items.fold(0.0, (total, item) => total + item.totalPrice);

  int get totalItems => items.fold(0, (total, item) => total + item.quantity);

  bool get isEmpty => items.isEmpty;

  CartModel copyWith({
    List<CartItemModel>? items,
  }) {
    return CartModel(
      items: items ?? this.items,
    );
  }

  CartModel addItem(CartItemModel item) {
    final existingItemIndex = items.indexWhere(
      (i) => i.food.id == item.food.id,
    );

    if (existingItemIndex != -1) {
      final updatedItems = [...items];
      updatedItems[existingItemIndex] = items[existingItemIndex].copyWith(
        quantity: items[existingItemIndex].quantity + item.quantity,
      );

      return copyWith(items: updatedItems);
    } else {
      return copyWith(items: [...items, item]);
    }
  }

  CartModel removeItem(String itemId) {
    return copyWith(
      items: items.where((item) => item.id != itemId).toList(),
    );
  }

  CartModel updateItemQuantity(String itemId, int quantity) {
    return copyWith(
      items: items.map((item) {
        if (item.id == itemId) {
          return item.copyWith(quantity: quantity);
        }
        return item;
      }).toList(),
    );
  }

  CartModel clear() {
    return CartModel.empty();
  }
}
