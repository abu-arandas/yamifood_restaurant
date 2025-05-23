import 'package:cloud_firestore/cloud_firestore.dart';

class RestaurantModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String coverImage;
  final String cuisine;
  final double rating;
  final int totalRatings;
  final int estimatedDeliveryTime;
  final double deliveryFee;
  final double minOrder;
  final bool isOpen;
  final Map<String, dynamic> location;
  final List<String> categories;
  final Map<String, dynamic>? openingHours;
  final List<String>? popularItems;
  final Map<String, dynamic>? contactInfo;
  final List<String>? paymentMethods;
  final Map<String, dynamic>? deliveryZones;
  final double? averagePreparationTime;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.coverImage,
    required this.cuisine,
    required this.rating,
    required this.totalRatings,
    required this.estimatedDeliveryTime,
    required this.deliveryFee,
    required this.minOrder,
    required this.isOpen,
    required this.location,
    required this.categories,
    this.openingHours,
    this.popularItems,
    this.contactInfo,
    this.paymentMethods,
    this.deliveryZones,
    this.averagePreparationTime,
  });

  bool get isValidRating => rating >= 0 && rating <= 5;
  bool get isValidDeliveryTime => estimatedDeliveryTime > 0;
  bool get isValidMinOrder => minOrder >= 0;
  bool get isValid => isValidRating && isValidDeliveryTime && isValidMinOrder;

  bool isOpenNow() {
    if (openingHours == null) return isOpen;
    final now = DateTime.now();
    final dayOfWeek = now.weekday.toString();
    final currentTime = '${now.hour}:${now.minute}';

    final todayHours = openingHours![dayOfWeek];
    if (todayHours == null) return false;

    return currentTime.compareTo(todayHours['open']) >= 0 && currentTime.compareTo(todayHours['close']) <= 0;
  }

  bool isInDeliveryZone(Map<String, dynamic> userLocation) {
    if (deliveryZones == null) return true;
    // Implement delivery zone check logic here
    return true; // Placeholder
  }

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imageUrl: json['imageUrl'] as String,
      coverImage: json['coverImage'] as String,
      cuisine: json['cuisine'] as String,
      rating: (json['rating'] as num).toDouble(),
      totalRatings: json['totalRatings'] as int,
      estimatedDeliveryTime: json['estimatedDeliveryTime'] as int,
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      minOrder: (json['minOrder'] as num).toDouble(),
      isOpen: json['isOpen'] as bool,
      location: json['location'] as Map<String, dynamic>,
      categories: List<String>.from(json['categories'] as List),
      openingHours: json['openingHours'] as Map<String, dynamic>?,
      popularItems: json['popularItems'] as List<String>?,
      contactInfo: json['contactInfo'] as Map<String, dynamic>?,
      paymentMethods: json['paymentMethods'] as List<String>?,
      deliveryZones: json['deliveryZones'] as Map<String, dynamic>?,
      averagePreparationTime: json['averagePreparationTime'] as double?,
    );
  }

  factory RestaurantModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return RestaurantModel(
      id: doc.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      imageUrl: data['imageUrl'] ?? '',
      coverImage: data['coverImage'] ?? '',
      cuisine: data['cuisine'] ?? '',
      rating: (data['rating'] ?? 0.0).toDouble(),
      totalRatings: data['totalRatings'] ?? 0,
      estimatedDeliveryTime: data['estimatedDeliveryTime'] ?? 30,
      deliveryFee: (data['deliveryFee'] ?? 0.0).toDouble(),
      minOrder: (data['minOrder'] ?? 0.0).toDouble(),
      isOpen: data['isOpen'] ?? false,
      location: data['location'] ?? {},
      categories: List<String>.from(data['categories'] ?? []),
      openingHours: data['openingHours'],
      popularItems: data['popularItems'] as List<String>?,
      contactInfo: data['contactInfo'] as Map<String, dynamic>?,
      paymentMethods: data['paymentMethods'] as List<String>?,
      deliveryZones: data['deliveryZones'] as Map<String, dynamic>?,
      averagePreparationTime: data['averagePreparationTime'] as double?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'coverImage': coverImage,
      'cuisine': cuisine,
      'rating': rating,
      'totalRatings': totalRatings,
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'deliveryFee': deliveryFee,
      'minOrder': minOrder,
      'isOpen': isOpen,
      'location': location,
      'categories': categories,
      'openingHours': openingHours,
      'popularItems': popularItems,
      'contactInfo': contactInfo,
      'paymentMethods': paymentMethods,
      'deliveryZones': deliveryZones,
      'averagePreparationTime': averagePreparationTime,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'coverImage': coverImage,
      'cuisine': cuisine,
      'rating': rating,
      'totalRatings': totalRatings,
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'deliveryFee': deliveryFee,
      'minOrder': minOrder,
      'isOpen': isOpen,
      'location': location,
      'categories': categories,
      'openingHours': openingHours,
      'popularItems': popularItems,
      'contactInfo': contactInfo,
      'paymentMethods': paymentMethods,
      'deliveryZones': deliveryZones,
      'averagePreparationTime': averagePreparationTime,
    };
  }

  RestaurantModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? coverImage,
    String? cuisine,
    double? rating,
    int? totalRatings,
    int? estimatedDeliveryTime,
    double? deliveryFee,
    double? minOrder,
    bool? isOpen,
    Map<String, dynamic>? location,
    List<String>? categories,
    Map<String, dynamic>? openingHours,
    List<String>? popularItems,
    Map<String, dynamic>? contactInfo,
    List<String>? paymentMethods,
    Map<String, dynamic>? deliveryZones,
    double? averagePreparationTime,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      coverImage: coverImage ?? this.coverImage,
      cuisine: cuisine ?? this.cuisine,
      rating: rating ?? this.rating,
      totalRatings: totalRatings ?? this.totalRatings,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      minOrder: minOrder ?? this.minOrder,
      isOpen: isOpen ?? this.isOpen,
      location: location ?? this.location,
      categories: categories ?? this.categories,
      openingHours: openingHours ?? this.openingHours,
      popularItems: popularItems ?? this.popularItems,
      contactInfo: contactInfo ?? this.contactInfo,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      deliveryZones: deliveryZones ?? this.deliveryZones,
      averagePreparationTime: averagePreparationTime ?? this.averagePreparationTime,
    );
  }
}
