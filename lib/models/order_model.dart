import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

enum OrderStatus {
  pending,
  confirmed,
  preparing,
  ready,
  onTheWay,
  delivered,
  cancelled,
}

class OrderModel {
  final String id;
  final String customerId;
  final String restaurantId;
  final String? driverId;
  final List<OrderItem> items;
  final double totalAmount;
  final OrderStatus status;
  final String paymentStatus;
  final String paymentMethod;
  final LatLng deliveryAddress;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String restaurantName;
  final Map<String, dynamic> restaurantLocation;
  final double? subtotal;
  final double? deliveryFee;
  final double? tax;
  final double? tip;
  final String? promoCode;
  final double? discount;
  final Map<String, dynamic>? customerNotes;
  final DateTime? scheduledDeliveryTime;
  final Map<String, dynamic>? deliveryInstructions;
  final int? estimatedDeliveryTime;
  final Map<String, dynamic>? driverLocation;

  OrderModel({
    required this.id,
    required this.customerId,
    required this.restaurantId,
    this.driverId,
    required this.items,
    required this.totalAmount,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.deliveryAddress,
    required this.createdAt,
    this.updatedAt,
    required this.restaurantName,
    required this.restaurantLocation,
    this.subtotal,
    this.deliveryFee,
    this.tax,
    this.tip,
    this.promoCode,
    this.discount,
    this.customerNotes,
    this.scheduledDeliveryTime,
    this.deliveryInstructions,
    this.estimatedDeliveryTime,
    this.driverLocation,
  });

  // Add validation methods
  bool get isValidTotal => totalAmount >= 0;
  bool get isValid => isValidTotal;

  // Add helper methods
  double getTotalWithTip() => totalAmount + (tip ?? 0);
  bool isScheduled() => scheduledDeliveryTime != null;
  bool isDelivered() => status == OrderStatus.delivered;
  bool isCancelled() => status == OrderStatus.cancelled;
  bool canBeCancelled() => status == OrderStatus.pending || status == OrderStatus.confirmed;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      customerId: json['customerId'] as String,
      restaurantId: json['restaurantId'] as String,
      driverId: json['driverId'] as String?,
      items: (json['items'] as List).map((item) => OrderItem.fromJson(item as Map<String, dynamic>)).toList(),
      totalAmount: (json['totalAmount'] as num).toDouble(),
      status: OrderStatus.values.firstWhere((e) => e.toString() == 'OrderStatus.${json['status']}'),
      paymentStatus: json['paymentStatus'] as String,
      paymentMethod: json['paymentMethod'] as String,
      deliveryAddress: LatLng.fromJson(json['deliveryAddress'])!,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      restaurantName: json['restaurantName'] as String,
      restaurantLocation: json['restaurantLocation'] as Map<String, dynamic>,
      subtotal: json['subtotal'] as double?,
      deliveryFee: json['deliveryFee'] as double?,
      tax: json['tax'] as double?,
      tip: json['tip'] as double?,
      promoCode: json['promoCode'] as String?,
      discount: json['discount'] as double?,
      customerNotes: json['customerNotes'] as Map<String, dynamic>?,
      scheduledDeliveryTime:
          json['scheduledDeliveryTime'] != null ? DateTime.parse(json['scheduledDeliveryTime'] as String) : null,
      deliveryInstructions: json['deliveryInstructions'] as Map<String, dynamic>?,
      estimatedDeliveryTime: json['estimatedDeliveryTime'] as int?,
      driverLocation: json['driverLocation'] as Map<String, dynamic>?,
    );
  }

  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      customerId: data['customerId'] ?? '',
      restaurantId: data['restaurantId'] ?? '',
      driverId: data['driverId'] as String?,
      items: (data['items'] as List).map((item) => OrderItem.fromJson(item as Map<String, dynamic>)).toList(),
      totalAmount: (data['totalAmount'] ?? 0.0).toDouble(),
      status: OrderStatus.values.firstWhere(
        (e) => e.toString() == 'OrderStatus.${data['status']}',
        orElse: () => OrderStatus.pending,
      ),
      paymentStatus: data['paymentStatus'] ?? 'pending',
      paymentMethod: data['paymentMethod'] ?? '',
      deliveryAddress: LatLng.fromJson(data['deliveryAddress'])!,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null ? (data['updatedAt'] as Timestamp).toDate() : null,
      restaurantName: data['restaurantName'] ?? '',
      restaurantLocation: data['restaurantLocation'] ?? {},
      subtotal: data['subtotal'] as double?,
      deliveryFee: data['deliveryFee'] as double?,
      tax: data['tax'] as double?,
      tip: data['tip'] as double?,
      promoCode: data['promoCode'] as String?,
      discount: data['discount'] as double?,
      customerNotes: data['customerNotes'] as Map<String, dynamic>?,
      scheduledDeliveryTime:
          data['scheduledDeliveryTime'] != null ? (data['scheduledDeliveryTime'] as Timestamp).toDate() : null,
      deliveryInstructions: data['deliveryInstructions'] as Map<String, dynamic>?,
      estimatedDeliveryTime: data['estimatedDeliveryTime'] as int?,
      driverLocation: data['driverLocation'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customerId': customerId,
      'restaurantId': restaurantId,
      'driverId': driverId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status.toString().split('.').last,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'deliveryAddress': deliveryAddress.toJson(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'restaurantName': restaurantName,
      'restaurantLocation': restaurantLocation,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'tip': tip,
      'promoCode': promoCode,
      'discount': discount,
      'customerNotes': customerNotes,
      'scheduledDeliveryTime': scheduledDeliveryTime?.toIso8601String(),
      'deliveryInstructions': deliveryInstructions,
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'driverLocation': driverLocation,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'customerId': customerId,
      'restaurantId': restaurantId,
      'driverId': driverId,
      'items': items.map((item) => item.toJson()).toList(),
      'totalAmount': totalAmount,
      'status': status.toString().split('.').last,
      'paymentStatus': paymentStatus,
      'paymentMethod': paymentMethod,
      'deliveryAddress': {
        'latitude': deliveryAddress.latitude,
        'longitude': deliveryAddress.longitude,
      },
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'restaurantName': restaurantName,
      'restaurantLocation': restaurantLocation,
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'tax': tax,
      'tip': tip,
      'promoCode': promoCode,
      'discount': discount,
      'customerNotes': customerNotes,
      'scheduledDeliveryTime': scheduledDeliveryTime != null ? Timestamp.fromDate(scheduledDeliveryTime!) : null,
      'deliveryInstructions': deliveryInstructions,
      'estimatedDeliveryTime': estimatedDeliveryTime,
      'driverLocation': driverLocation,
    };
  }

  OrderModel copyWith({
    String? id,
    String? customerId,
    String? restaurantId,
    String? driverId,
    List<OrderItem>? items,
    double? totalAmount,
    OrderStatus? status,
    String? paymentStatus,
    String? paymentMethod,
    LatLng? deliveryAddress,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? restaurantName,
    Map<String, dynamic>? restaurantLocation,
    double? subtotal,
    double? deliveryFee,
    double? tax,
    double? tip,
    String? promoCode,
    double? discount,
    Map<String, dynamic>? customerNotes,
    DateTime? scheduledDeliveryTime,
    Map<String, dynamic>? deliveryInstructions,
    int? estimatedDeliveryTime,
    Map<String, dynamic>? driverLocation,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      restaurantId: restaurantId ?? this.restaurantId,
      driverId: driverId ?? this.driverId,
      items: items ?? this.items,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantLocation: restaurantLocation ?? this.restaurantLocation,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      tax: tax ?? this.tax,
      tip: tip ?? this.tip,
      promoCode: promoCode ?? this.promoCode,
      discount: discount ?? this.discount,
      customerNotes: customerNotes ?? this.customerNotes,
      scheduledDeliveryTime: scheduledDeliveryTime ?? this.scheduledDeliveryTime,
      deliveryInstructions: deliveryInstructions ?? this.deliveryInstructions,
      estimatedDeliveryTime: estimatedDeliveryTime ?? this.estimatedDeliveryTime,
      driverLocation: driverLocation ?? this.driverLocation,
    );
  }
}

class OrderItem {
  final String id;
  final String name;
  final double price;
  final int quantity;
  final String? notes;

  OrderItem({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    this.notes,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: json['quantity'] as int,
      notes: json['notes'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'quantity': quantity,
      'notes': notes,
    };
  }

  OrderItem copyWith({
    String? id,
    String? name,
    double? price,
    int? quantity,
    String? notes,
  }) {
    return OrderItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }
}
