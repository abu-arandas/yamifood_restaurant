import '../../exports.dart';

enum OrderStatus {
  pending,
  preparing,
  readyForPickup,
  outForDelivery,
  delivered,
  cancelled,
}

extension OrderStatusExtension on OrderStatus {
  String get name {
    switch (this) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.preparing:
        return 'Preparing';
      case OrderStatus.readyForPickup:
        return 'Ready for Pickup';
      case OrderStatus.outForDelivery:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }
}

class OrderModel {
  final String id;
  final UserModel user;
  final List<CartItemModel> items;
  final double subtotal;
  final double tax;
  final double deliveryFee;
  final double total;
  final String? deliveryAddress;
  final String? paymentMethod;
  final OrderStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;

  OrderModel({
    required this.id,
    required this.user,
    required this.items,
    required this.subtotal,
    required this.tax,
    required this.deliveryFee,
    required this.total,
    this.deliveryAddress,
    this.paymentMethod,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
  });

  factory OrderModel.fromCart({
    required String id,
    required UserModel user,
    required CartModel cart,
    required double taxRate,
    required double deliveryFee,
    String? deliveryAddress,
    String? paymentMethod,
  }) {
    final subtotal = cart.totalPrice;
    final tax = subtotal * taxRate;
    final total = subtotal + tax + deliveryFee;
    final now = DateTime.now();

    return OrderModel(
      id: id,
      user: user,
      items: cart.items,
      subtotal: subtotal,
      tax: tax,
      deliveryFee: deliveryFee,
      total: total,
      deliveryAddress: deliveryAddress,
      paymentMethod: paymentMethod,
      status: OrderStatus.pending,
      createdAt: now,
      updatedAt: now,
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      items: (json['items'] as List<dynamic>).map((e) => CartItemModel.fromJson(e as Map<String, dynamic>)).toList(),
      subtotal: (json['subtotal'] as num).toDouble(),
      tax: (json['tax'] as num).toDouble(),
      deliveryFee: (json['deliveryFee'] as num).toDouble(),
      total: (json['total'] as num).toDouble(),
      deliveryAddress: json['deliveryAddress'] as String?,
      paymentMethod: json['paymentMethod'] as String?,
      status: OrderStatus.values.byName(json['status'] as String),
      createdAt: (json['createdAt'] as Timestamp).toDate(),
      updatedAt: (json['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user': user.toJson(),
      'items': items.map((e) => e.toJson()).toList(),
      'subtotal': subtotal,
      'tax': tax,
      'deliveryFee': deliveryFee,
      'total': total,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      'status': status.name,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  OrderModel copyWith({
    String? id,
    UserModel? user,
    List<CartItemModel>? items,
    double? subtotal,
    double? tax,
    double? deliveryFee,
    double? total,
    String? deliveryAddress,
    String? paymentMethod,
    OrderStatus? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      user: user ?? this.user,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      total: total ?? this.total,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  OrderModel updateStatus(OrderStatus newStatus) {
    return copyWith(
      status: newStatus,
      updatedAt: DateTime.now(),
    );
  }
}
