class CartItemModel {
  final String id, name, imageUrl;
  final double price;
  int quantity;
  final String restaurantId, restaurantName;
  final List<String>? options;
  final String? specialInstructions;

  CartItemModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
    required this.restaurantId,
    required this.restaurantName,
    this.options,
    this.specialInstructions,
  });

  factory CartItemModel.fromJson(Map<String, dynamic> json) {
    return CartItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['imageUrl'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      restaurantId: json['restaurantId'] as String,
      restaurantName: json['restaurantName'] as String,
      options: (json['options'] as List?)?.map((e) => e as String).toList(),
      specialInstructions: json['specialInstructions'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'options': options,
      'specialInstructions': specialInstructions,
    };
  }

  double get total => price * quantity;

  CartItemModel copyWith({
    String? id,
    String? name,
    String? imageUrl,
    double? price,
    int? quantity,
    String? restaurantId,
    String? restaurantName,
    List<String>? options,
    String? specialInstructions,
  }) {
    return CartItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      options: options ?? this.options,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}
