import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole {
  admin,
  driver,
  customer,
}

class UserModel {
  final String id;
  final String email;
  final String name;
  final String? phoneNumber;
  final String? profileImage;
  final UserRole userRole;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isActive;
  final Map<String, dynamic>? additionalData;
  final String? fcmToken;
  final List<String>? favoriteRestaurants;
  final Map<String, dynamic>? preferences;

  UserModel({
    required this.id,
    required this.email,
    required this.name,
    this.phoneNumber,
    this.profileImage,
    required this.userRole,
    required this.createdAt,
    required this.updatedAt,
    this.isActive = true,
    this.additionalData,
    this.fcmToken,
    this.favoriteRestaurants,
    this.preferences,
  });

  bool get isValidEmail => RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  bool get isValidPhoneNumber => phoneNumber == null || RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(phoneNumber!);
  bool get isValid => isValidEmail && isValidPhoneNumber;

  bool isFavoriteRestaurant(String restaurantId) => favoriteRestaurants?.contains(restaurantId) ?? false;

  String? getPreference(String key) => preferences?[key]?.toString();

  factory UserModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      phoneNumber: data['phoneNumber'],
      profileImage: data['profileImage'],
      userRole: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${data['userRole']}',
        orElse: () => UserRole.customer,
      ),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      isActive: data['isActive'] ?? true,
      additionalData: data['additionalData'],
      fcmToken: data['fcmToken'],
      favoriteRestaurants: data['favoriteRestaurants'],
      preferences: data['preferences'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'phoneNumber': phoneNumber,
      'profileImage': profileImage,
      'userRole': userRole,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'isActive': isActive,
      'additionalData': additionalData,
      'fcmToken': fcmToken,
      'favoriteRestaurants': favoriteRestaurants,
      'preferences': preferences,
    };
  }

  UserModel copyWith({
    String? id,
    String? email,
    String? name,
    String? phoneNumber,
    String? profileImage,
    UserRole? userRole,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isActive,
    Map<String, dynamic>? additionalData,
    String? fcmToken,
    List<String>? favoriteRestaurants,
    Map<String, dynamic>? preferences,
  }) {
    return UserModel(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      userRole: userRole ?? this.userRole,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isActive: isActive ?? this.isActive,
      additionalData: additionalData ?? this.additionalData,
      fcmToken: fcmToken ?? this.fcmToken,
      favoriteRestaurants: favoriteRestaurants ?? this.favoriteRestaurants,
      preferences: preferences ?? this.preferences,
    );
  }
}
