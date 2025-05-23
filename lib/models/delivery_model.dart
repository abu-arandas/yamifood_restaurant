import 'package:cloud_firestore/cloud_firestore.dart';

enum DeliveryStatus {
  pending,
  assigned,
  pickedUp,
  inTransit,
  delivered,
  cancelled,
}

class DeliveryModel {
  final String id;
  final String orderId;
  final String driverId;
  final String restaurantId;
  final String customerId;
  final DeliveryStatus status;
  final Map<String, dynamic>? driverLocation;
  final Map<String, dynamic>? restaurantLocation;
  final Map<String, dynamic>? customerLocation;
  final DateTime? assignedAt;
  final DateTime? pickedUpAt;
  final DateTime? deliveredAt;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final double? distance;
  final int? estimatedTime;
  final Map<String, dynamic>? routeDetails;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? driverName;
  final String? driverPhone;
  final Map<String, dynamic>? vehicleInfo;
  final Map<String, dynamic>? deliveryNotes;
  final double? actualDeliveryTime;
  final Map<String, dynamic>? customerFeedback;
  final double? driverRating;

  DeliveryModel({
    required this.id,
    required this.orderId,
    required this.driverId,
    required this.restaurantId,
    required this.customerId,
    required this.status,
    this.driverLocation,
    this.restaurantLocation,
    this.customerLocation,
    this.assignedAt,
    this.pickedUpAt,
    this.deliveredAt,
    this.cancelledAt,
    this.cancellationReason,
    this.distance,
    this.estimatedTime,
    this.routeDetails,
    required this.createdAt,
    required this.updatedAt,
    this.driverName,
    this.driverPhone,
    this.vehicleInfo,
    this.deliveryNotes,
    this.actualDeliveryTime,
    this.customerFeedback,
    this.driverRating,
  });

  // Add validation methods
  bool get isValidDistance => distance == null || distance! >= 0;
  bool get isValidEstimatedTime => estimatedTime == null || estimatedTime! > 0;
  bool get isValid => isValidDistance && isValidEstimatedTime;

  // Add helper methods
  bool isInProgress() =>
      status == DeliveryStatus.assigned || status == DeliveryStatus.pickedUp || status == DeliveryStatus.inTransit;

  bool canBeCancelled() => status == DeliveryStatus.pending || status == DeliveryStatus.assigned;

  double? getActualDeliveryTime() {
    if (deliveredAt == null || pickedUpAt == null) return null;
    return deliveredAt!.difference(pickedUpAt!).inMinutes.toDouble();
  }

  bool isDelayed() {
    if (estimatedTime == null || actualDeliveryTime == null) return false;
    return actualDeliveryTime! > estimatedTime!;
  }

  factory DeliveryModel.fromJson(Map<String, dynamic> json) {
    return DeliveryModel(
      id: json['id'] as String,
      orderId: json['orderId'] as String,
      driverId: json['driverId'] as String,
      restaurantId: json['restaurantId'] as String,
      customerId: json['customerId'] as String,
      status: DeliveryStatus.values.firstWhere((e) => e.toString() == json['status']),
      driverLocation: json['driverLocation'] as Map<String, dynamic>?,
      restaurantLocation: json['restaurantLocation'] as Map<String, dynamic>?,
      customerLocation: json['customerLocation'] as Map<String, dynamic>?,
      assignedAt: json['assignedAt'] != null ? DateTime.parse(json['assignedAt'] as String) : null,
      pickedUpAt: json['pickedUpAt'] != null ? DateTime.parse(json['pickedUpAt'] as String) : null,
      deliveredAt: json['deliveredAt'] != null ? DateTime.parse(json['deliveredAt'] as String) : null,
      cancelledAt: json['cancelledAt'] != null ? DateTime.parse(json['cancelledAt'] as String) : null,
      cancellationReason: json['cancellationReason'] as String?,
      distance: json['distance']?.toDouble(),
      estimatedTime: json['estimatedTime'] as int?,
      routeDetails: json['routeDetails'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      driverName: json['driverName'] as String?,
      driverPhone: json['driverPhone'] as String?,
      vehicleInfo: json['vehicleInfo'] as Map<String, dynamic>?,
      deliveryNotes: json['deliveryNotes'] as Map<String, dynamic>?,
      actualDeliveryTime: json['actualDeliveryTime']?.toDouble(),
      customerFeedback: json['customerFeedback'] as Map<String, dynamic>?,
      driverRating: json['driverRating']?.toDouble(),
    );
  }

  factory DeliveryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DeliveryModel(
      id: doc.id,
      orderId: data['orderId'] as String,
      driverId: data['driverId'] as String,
      restaurantId: data['restaurantId'] as String,
      customerId: data['customerId'] as String,
      status: DeliveryStatus.values.firstWhere((e) => e.toString() == data['status']),
      driverLocation: data['driverLocation'] as Map<String, dynamic>?,
      restaurantLocation: data['restaurantLocation'] as Map<String, dynamic>?,
      customerLocation: data['customerLocation'] as Map<String, dynamic>?,
      assignedAt: data['assignedAt'] != null ? (data['assignedAt'] as Timestamp).toDate() : null,
      pickedUpAt: data['pickedUpAt'] != null ? (data['pickedUpAt'] as Timestamp).toDate() : null,
      deliveredAt: data['deliveredAt'] != null ? (data['deliveredAt'] as Timestamp).toDate() : null,
      cancelledAt: data['cancelledAt'] != null ? (data['cancelledAt'] as Timestamp).toDate() : null,
      cancellationReason: data['cancellationReason'] as String?,
      distance: data['distance']?.toDouble(),
      estimatedTime: data['estimatedTime'] as int?,
      routeDetails: data['routeDetails'] as Map<String, dynamic>?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
      driverName: data['driverName'] as String?,
      driverPhone: data['driverPhone'] as String?,
      vehicleInfo: data['vehicleInfo'] as Map<String, dynamic>?,
      deliveryNotes: data['deliveryNotes'] as Map<String, dynamic>?,
      actualDeliveryTime: data['actualDeliveryTime']?.toDouble(),
      customerFeedback: data['customerFeedback'] as Map<String, dynamic>?,
      driverRating: data['driverRating']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'orderId': orderId,
      'driverId': driverId,
      'restaurantId': restaurantId,
      'customerId': customerId,
      'status': status.toString(),
      'driverLocation': driverLocation,
      'restaurantLocation': restaurantLocation,
      'customerLocation': customerLocation,
      'assignedAt': assignedAt?.toIso8601String(),
      'pickedUpAt': pickedUpAt?.toIso8601String(),
      'deliveredAt': deliveredAt?.toIso8601String(),
      'cancelledAt': cancelledAt?.toIso8601String(),
      'cancellationReason': cancellationReason,
      'distance': distance,
      'estimatedTime': estimatedTime,
      'routeDetails': routeDetails,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'driverName': driverName,
      'driverPhone': driverPhone,
      'vehicleInfo': vehicleInfo,
      'deliveryNotes': deliveryNotes,
      'actualDeliveryTime': actualDeliveryTime,
      'customerFeedback': customerFeedback,
      'driverRating': driverRating,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'orderId': orderId,
      'driverId': driverId,
      'restaurantId': restaurantId,
      'customerId': customerId,
      'status': status.toString(),
      'driverLocation': driverLocation,
      'restaurantLocation': restaurantLocation,
      'customerLocation': customerLocation,
      'assignedAt': assignedAt != null ? Timestamp.fromDate(assignedAt!) : null,
      'pickedUpAt': pickedUpAt != null ? Timestamp.fromDate(pickedUpAt!) : null,
      'deliveredAt': deliveredAt != null ? Timestamp.fromDate(deliveredAt!) : null,
      'cancelledAt': cancelledAt != null ? Timestamp.fromDate(cancelledAt!) : null,
      'cancellationReason': cancellationReason,
      'distance': distance,
      'estimatedTime': estimatedTime,
      'routeDetails': routeDetails,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'driverName': driverName,
      'driverPhone': driverPhone,
      'vehicleInfo': vehicleInfo,
      'deliveryNotes': deliveryNotes,
      'actualDeliveryTime': actualDeliveryTime,
      'customerFeedback': customerFeedback,
      'driverRating': driverRating,
    };
  }

  DeliveryModel copyWith({
    String? id,
    String? orderId,
    String? driverId,
    String? restaurantId,
    String? customerId,
    DeliveryStatus? status,
    Map<String, dynamic>? driverLocation,
    Map<String, dynamic>? restaurantLocation,
    Map<String, dynamic>? customerLocation,
    DateTime? assignedAt,
    DateTime? pickedUpAt,
    DateTime? deliveredAt,
    DateTime? cancelledAt,
    String? cancellationReason,
    double? distance,
    int? estimatedTime,
    Map<String, dynamic>? routeDetails,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? driverName,
    String? driverPhone,
    Map<String, dynamic>? vehicleInfo,
    Map<String, dynamic>? deliveryNotes,
    double? actualDeliveryTime,
    Map<String, dynamic>? customerFeedback,
    double? driverRating,
  }) {
    return DeliveryModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      driverId: driverId ?? this.driverId,
      restaurantId: restaurantId ?? this.restaurantId,
      customerId: customerId ?? this.customerId,
      status: status ?? this.status,
      driverLocation: driverLocation ?? this.driverLocation,
      restaurantLocation: restaurantLocation ?? this.restaurantLocation,
      customerLocation: customerLocation ?? this.customerLocation,
      assignedAt: assignedAt ?? this.assignedAt,
      pickedUpAt: pickedUpAt ?? this.pickedUpAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      cancelledAt: cancelledAt ?? this.cancelledAt,
      cancellationReason: cancellationReason ?? this.cancellationReason,
      distance: distance ?? this.distance,
      estimatedTime: estimatedTime ?? this.estimatedTime,
      routeDetails: routeDetails ?? this.routeDetails,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      vehicleInfo: vehicleInfo ?? this.vehicleInfo,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
      actualDeliveryTime: actualDeliveryTime ?? this.actualDeliveryTime,
      customerFeedback: customerFeedback ?? this.customerFeedback,
      driverRating: driverRating ?? this.driverRating,
    );
  }
}
