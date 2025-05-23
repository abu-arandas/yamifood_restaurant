import 'package:cloud_firestore/cloud_firestore.dart';

class AddressModel {
  final String id, userId, street, city, state, zipCode;
  final String? apartment, instructions;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime? updatedAt;

  AddressModel({
    required this.id,
    required this.userId,
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    this.apartment,
    this.instructions,
    this.isDefault = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory AddressModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AddressModel(
      id: doc.id,
      userId: data['userId'] as String,
      street: data['street'] as String,
      city: data['city'] as String,
      state: data['state'] as String,
      zipCode: data['zipCode'] as String,
      apartment: data['apartment'] as String?,
      instructions: data['instructions'] as String?,
      isDefault: data['isDefault'] as bool? ?? false,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'street': street,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'apartment': apartment,
      'instructions': instructions,
      'isDefault': isDefault,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt,
    };
  }

  AddressModel copyWith({
    String? id,
    String? userId,
    String? street,
    String? city,
    String? state,
    String? zipCode,
    String? apartment,
    String? instructions,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AddressModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      street: street ?? this.street,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      apartment: apartment ?? this.apartment,
      instructions: instructions ?? this.instructions,
      isDefault: isDefault ?? this.isDefault,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
