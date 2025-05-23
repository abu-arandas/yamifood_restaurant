import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'cart_item_model.dart';

enum CartStatus {
  active,
  checkingOut,
  completed,
  abandoned,
}

class CartModel {
  final String id, customerId, restaurantId, restaurantName;
  final List<CartItemModel> items;
  final double subtotal, deliveryFee, tax, total;
  final String? promoCode;
  final double? discount;
  final Map<String, LatLng>? deliveryAddress;
  final CartStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  CartModel({
    required this.id,
    required this.customerId,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.tax,
    required this.total,
    this.promoCode,
    this.discount,
    this.deliveryAddress,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CartModel.empty(String customerId) {
    return CartModel(
      id: '',
      customerId: customerId,
      restaurantId: '',
      restaurantName: '',
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

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      restaurantId: json['restaurantId'] as String,
      restaurantName: json['restaurantName'] as String,
      items: (json['items'] as List).map((item) => CartItemModel.fromJson(item as Map<String, dynamic>)).toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      promoCode: json['promoCode'] as String?,
      discount: json['discount']?.toDouble(),
      deliveryAddress: json['deliveryAddress'] as Map<String, LatLng>?,
      status: CartStatus.values.firstWhere((e) => e.toString() == json['status']),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  factory CartModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CartModel(
      id: doc.id,
      customerId: data['customerId'] as String,
      restaurantId: data['restaurantId'] as String,
      restaurantName: data['restaurantName'] as String,
      items: (data['items'] as List).map((item) => CartItemModel.fromJson(item as Map<String, dynamic>)).toList(),
      subtotal: (data['subtotal'] as num).toDouble(),
      deliveryFee: (data['deliveryFee'] as num).toDouble(),
      tax: (data['tax'] as num).toDouble(),
      total: (data['total'] as num).toDouble(),
      promoCode: data['promoCode'] as String?,
      discount: data['discount']?.toDouble(),
      deliveryAddress: data['deliveryAddress'] as Map<String, LatLng>?,
      status: CartStatus.values.firstWhere((e) => e.toString() == data['status']),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'total': total,
      'promoCode': promoCode,
      'discount': discount,
      'deliveryAddress': deliveryAddress,
      'status': status.toString(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'customerId': customerId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'total': total,
      'promoCode': promoCode,
      'discount': discount,
      'deliveryAddress': deliveryAddress,
      'status': status.toString(),
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  CartModel copyWith({
    String? id,
    String? customerId,
    String? restaurantId,
    String? restaurantName,
    List<CartItemModel>? items,
    double? subtotal,
    double? deliveryFee,
    double? tax,
    double? total,
    String? promoCode,
    double? discount,
    Map<String, LatLng>? deliveryAddress,
    CartStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CartModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      promoCode: promoCode ?? this.promoCode,
      discount: discount ?? this.discount,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  int get itemCount => items.fold(0, (total, item) => total + item.quantity);
}
