import 'package:cloud_firestore/cloud_firestore.dart';

class MenuItemModel {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final List<String> categories;
  final bool isAvailable;
  final List<String> ingredients;
  final Map<String, dynamic> nutritionalInfo;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<MenuItemOption>? options;
  final List<String>? allergens;
  final int? preparationTime;
  final bool isSpicy;
  final bool isVegetarian;
  final bool isVegan;
  final int? popularity;

  MenuItemModel({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.categories,
    required this.isAvailable,
    required this.ingredients,
    required this.nutritionalInfo,
    required this.createdAt,
    required this.updatedAt,
    this.options,
    this.allergens,
    this.preparationTime,
    this.isSpicy = false,
    this.isVegetarian = false,
    this.isVegan = false,
    this.popularity,
  });

  bool get isValid => _validate();
  bool get isValidPrice => price >= 0;
  bool get hasImage => imageUrl.isNotEmpty;
  bool get hasOptions => options != null && options!.isNotEmpty;
  bool get hasAllergens => allergens != null && allergens!.isNotEmpty;
  bool get isCustomizable => hasOptions;
  bool get isPopular => popularity != null && popularity! > 100;
  bool get isQuickToPrepare => preparationTime != null && preparationTime! <= 15;
  bool get isHealthy => nutritionalInfo['calories'] != null && (nutritionalInfo['calories'] as num) <= 500;

  bool _validate() {
    if (name.isEmpty) return false;
    if (description.isEmpty) return false;
    if (!isValidPrice) return false;
    if (restaurantId.isEmpty) return false;
    if (categories.isEmpty) return false;
    if (ingredients.isEmpty) return false;
    if (nutritionalInfo.isEmpty) return false;
    return true;
  }

  bool hasAllergen(String allergen) => allergens?.contains(allergen) ?? false;
  bool hasCategory(String category) => categories.contains(category);
  bool hasIngredient(String ingredient) => ingredients.contains(ingredient);
  bool isInPriceRange(double minPrice, double maxPrice) => price >= minPrice && price <= maxPrice;

  double getTotalPriceWithOptions() {
    if (!hasOptions) return price;
    return price + options!.fold(0.0, (total, option) => total + option.price);
  }

  double getNutritionalValue(String key) {
    return (nutritionalInfo[key] as num?)?.toDouble() ?? 0.0;
  }

  List<String> getDietaryInfo() {
    final info = <String>[];
    if (isVegetarian) info.add('Vegetarian');
    if (isVegan) info.add('Vegan');
    if (isSpicy) info.add('Spicy');
    return info;
  }

  String getPreparationTimeString() {
    if (preparationTime == null) return 'Time not specified';
    return '$preparationTime minutes';
  }

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      id: json['id'] as String,
      restaurantId: json['restaurantId'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'] as String,
      categories: List<String>.from(json['categories'] as List),
      isAvailable: json['isAvailable'] as bool,
      ingredients: List<String>.from(json['ingredients'] as List),
      nutritionalInfo: json['nutritionalInfo'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      options: (json['options'] as List?)?.map((e) => MenuItemOption.fromJson(e as Map<String, dynamic>)).toList(),
      allergens: (json['allergens'] as List?)?.map((e) => e as String).toList(),
      preparationTime: json['preparationTime'] as int?,
      isSpicy: json['isSpicy'] as bool? ?? false,
      isVegetarian: json['isVegetarian'] as bool? ?? false,
      isVegan: json['isVegan'] as bool? ?? false,
      popularity: json['popularity'] as int?,
    );
  }

  factory MenuItemModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return MenuItemModel(
      id: doc.id,
      restaurantId: data['restaurantId'] as String,
      name: data['name'] as String,
      description: data['description'] as String,
      price: (data['price'] as num).toDouble(),
      imageUrl: data['imageUrl'] as String,
      categories: List<String>.from(data['categories'] as List),
      isAvailable: data['isAvailable'] as bool,
      ingredients: List<String>.from(data['ingredients'] as List),
      nutritionalInfo: data['nutritionalInfo'] as Map<String, dynamic>,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      options: (data['options'] as List?)?.map((e) => MenuItemOption.fromJson(e as Map<String, dynamic>)).toList(),
      allergens: (data['allergens'] as List?)?.map((e) => e as String).toList(),
      preparationTime: data['preparationTime'] as int?,
      isSpicy: data['isSpicy'] as bool? ?? false,
      isVegetarian: data['isVegetarian'] as bool? ?? false,
      isVegan: data['isVegan'] as bool? ?? false,
      popularity: data['popularity'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'categories': categories,
      'isAvailable': isAvailable,
      'ingredients': ingredients,
      'nutritionalInfo': nutritionalInfo,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'options': options?.map((o) => o.toJson()).toList(),
      'allergens': allergens,
      'preparationTime': preparationTime,
      'isSpicy': isSpicy,
      'isVegetarian': isVegetarian,
      'isVegan': isVegan,
      'popularity': popularity,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'restaurantId': restaurantId,
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'categories': categories,
      'isAvailable': isAvailable,
      'ingredients': ingredients,
      'nutritionalInfo': nutritionalInfo,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'options': options?.map((o) => o.toJson()).toList(),
      'allergens': allergens,
      'preparationTime': preparationTime,
      'isSpicy': isSpicy,
      'isVegetarian': isVegetarian,
      'isVegan': isVegan,
      'popularity': popularity,
    };
  }

  MenuItemModel copyWith({
    String? id,
    String? restaurantId,
    String? name,
    String? description,
    double? price,
    String? imageUrl,
    List<String>? categories,
    bool? isAvailable,
    List<String>? ingredients,
    Map<String, dynamic>? nutritionalInfo,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<MenuItemOption>? options,
    List<String>? allergens,
    int? preparationTime,
    bool? isSpicy,
    bool? isVegetarian,
    bool? isVegan,
    int? popularity,
  }) {
    return MenuItemModel(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      categories: categories ?? this.categories,
      isAvailable: isAvailable ?? this.isAvailable,
      ingredients: ingredients ?? this.ingredients,
      nutritionalInfo: nutritionalInfo ?? this.nutritionalInfo,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      options: options ?? this.options,
      allergens: allergens ?? this.allergens,
      preparationTime: preparationTime ?? this.preparationTime,
      isSpicy: isSpicy ?? this.isSpicy,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isVegan: isVegan ?? this.isVegan,
      popularity: popularity ?? this.popularity,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuItemModel &&
        other.id == id &&
        other.restaurantId == restaurantId &&
        other.name == name &&
        other.description == description &&
        other.price == price &&
        other.imageUrl == imageUrl &&
        other.categories.length == categories.length &&
        other.categories.every((category) => categories.contains(category)) &&
        other.isAvailable == isAvailable &&
        other.ingredients.length == ingredients.length &&
        other.ingredients.every((ingredient) => ingredients.contains(ingredient)) &&
        other.nutritionalInfo.length == nutritionalInfo.length &&
        other.nutritionalInfo.entries.every((entry) => nutritionalInfo[entry.key] == entry.value) &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        (other.options == null && options == null ||
            (other.options != null && options != null && other.options!.length == options!.length)) &&
        (other.allergens == null && allergens == null ||
            (other.allergens != null && allergens != null && other.allergens!.length == allergens!.length)) &&
        other.preparationTime == preparationTime &&
        other.isSpicy == isSpicy &&
        other.isVegetarian == isVegetarian &&
        other.isVegan == isVegan &&
        other.popularity == popularity;
  }

  @override
  int get hashCode {
    return Object.hash(
      id,
      restaurantId,
      name,
      description,
      price,
      imageUrl,
      Object.hashAll(categories),
      isAvailable,
      Object.hashAll(ingredients),
      Object.hashAll(nutritionalInfo.entries),
      createdAt,
      updatedAt,
      options != null ? Object.hashAll(options!) : null,
      allergens != null ? Object.hashAll(allergens!) : null,
      preparationTime,
      isSpicy,
      isVegetarian,
      isVegan,
      popularity,
    );
  }

  @override
  String toString() {
    return 'MenuItemModel(id: $id, name: $name, price: $price, isAvailable: $isAvailable)';
  }
}

class MenuItemOption {
  final String name;
  final double price;
  final bool isRequired;
  final List<String>? choices;

  MenuItemOption({
    required this.name,
    required this.price,
    this.isRequired = false,
    this.choices,
  });

  bool get isValid => name.isNotEmpty && price >= 0;
  bool get hasChoices => choices != null && choices!.isNotEmpty;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'isRequired': isRequired,
      'choices': choices,
    };
  }

  factory MenuItemOption.fromJson(Map<String, dynamic> json) {
    return MenuItemOption(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      isRequired: json['isRequired'] as bool? ?? false,
      choices: (json['choices'] as List?)?.map((e) => e as String).toList(),
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is MenuItemOption &&
        other.name == name &&
        other.price == price &&
        other.isRequired == isRequired &&
        (other.choices == null && choices == null ||
            (other.choices != null &&
                choices != null &&
                other.choices!.length == choices!.length &&
                other.choices!.every((choice) => choices!.contains(choice))));
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      price,
      isRequired,
      choices != null ? Object.hashAll(choices!) : null,
    );
  }

  @override
  String toString() {
    return 'MenuItemOption(name: $name, price: $price, isRequired: $isRequired)';
  }
}
