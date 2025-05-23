import 'package:cloud_firestore/cloud_firestore.dart';

class MenuModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String? imageUrl;
  final List<String> categories;
  final Map<String, dynamic> nutritionalInfo;
  final List<String> ingredients;
  final String restaurantId;
  final bool isAvailable;
  final DateTime createdAt;
  final DateTime updatedAt;

  MenuModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.imageUrl,
    required this.categories,
    required this.nutritionalInfo,
    required this.ingredients,
    required this.restaurantId,
    required this.isAvailable,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isValid => _validate();

  bool _validate() {
    if (name.isEmpty) return false;
    if (description.isEmpty) return false;
    if (price <= 0) return false;
    if (restaurantId.isEmpty) return false;
    if (categories.isEmpty) return false;
    return true;
  }

  bool hasCategory(String category) => categories.contains(category);

  bool hasIngredient(String ingredient) => ingredients.contains(ingredient);

  double getNutritionalValue(String key) {
    return (nutritionalInfo[key] as num?)?.toDouble() ?? 0.0;
  }

  bool isInPriceRange(double minPrice, double maxPrice) {
    return price >= minPrice && price <= maxPrice;
  }

  factory MenuModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MenuModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0.0).toDouble(),
      imageUrl: data['imageUrl'],
      categories: List<String>.from(data['categories'] ?? []),
      nutritionalInfo: Map<String, dynamic>.from(data['nutritionalInfo'] ?? {}),
      ingredients: List<String>.from(data['ingredients'] ?? []),
      restaurantId: data['restaurantId'] ?? '',
      isAvailable: data['isAvailable'] ?? true,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'categories': categories,
      'nutritionalInfo': nutritionalInfo,
      'ingredients': ingredients,
      'restaurantId': restaurantId,
      'isAvailable': isAvailable,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  MenuModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    List<String>? categories,
    Map<String, dynamic>? nutritionalInfo,
    List<String>? ingredients,
    String? restaurantId,
    bool? isAvailable,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return MenuModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      categories: categories ?? this.categories,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
      ingredients: ingredients ?? this.ingredients,
      restaurantId: restaurantId ?? this.restaurantId,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuModel &&
        other.id == id &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.imageUrl == imageUrl &&
        other.categories.length == categories.length &&
        other.categories.every((category) => categories.contains(category)) &&
        other.nutritionalInfo.length == nutritionalInfo.length &&
        other.nutritionalInfo.entries.every((entry) => nutritionalInfo[entry.key] == entry.value) &&
        other.ingredients.length == ingredients.length &&
        other.ingredients.every((ingredient) => ingredients.contains(ingredient)) &&
        other.restaurantId == restaurantId &&
        other.isAvailable == isAvailable &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        description.hashCode ^
        price.hashCode ^
        imageUrl.hashCode ^
        categories.hashCode ^
        nutritionalInfo.hashCode ^
        ingredients.hashCode ^
        restaurantId.hashCode ^
        isAvailable.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  @override
  String toString() {
    return 'MenuModel(id: $id, name: $name, price: $price, isAvailable: $isAvailable)';
  }
}
