import 'package:cloud_firestore/cloud_firestore.dart';

enum PaymentStatus {
  pending,
  processing,
  completed,
  failed,
  refunded,
  cancelled,
}

class PaymentModel {
  final String id;
  final String userId;
  final String orderId;
  final double amount;
  final String currency;
  final PaymentStatus status;
  final String paymentMethod;
  final Map<String, dynamic> paymentDetails;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final String? transactionId;
  final String? errorMessage;

  PaymentModel({
    required this.id,
    required this.userId,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.status,
    required this.paymentMethod,
    required this.paymentDetails,
    required this.createdAt,
    this.updatedAt,
    this.transactionId,
    this.errorMessage,
  });

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      orderId: json['orderId'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String,
      status: PaymentStatus.values.firstWhere((e) => e.toString() == 'PaymentStatus.${json['status']}'),
      paymentMethod: json['paymentMethod'] as String,
      paymentDetails: json['paymentDetails'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      transactionId: json['transactionId'] as String?,
      errorMessage: json['errorMessage'] as String?,
    );
  }

  factory PaymentModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PaymentModel(
      id: doc.id,
      userId: data['userId'] ?? '',
      orderId: data['orderId'] ?? '',
      amount: (data['amount'] ?? 0.0).toDouble(),
      currency: data['currency'] ?? 'USD',
      status: PaymentStatus.values.firstWhere(
        (e) => e.toString() == 'PaymentStatus.${data['status']}',
        orElse: () => PaymentStatus.pending,
      ),
      paymentMethod: data['paymentMethod'] ?? '',
      paymentDetails: Map<String, dynamic>.from(data['paymentDetails'] ?? {}),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      updatedAt: data['updatedAt'] != null ? (data['updatedAt'] as Timestamp).toDate() : null,
      transactionId: data['transactionId'] as String?,
      errorMessage: data['errorMessage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'orderId': orderId,
      'amount': amount,
      'currency': currency,
      'status': status.toString().split('.').last,
      'paymentMethod': paymentMethod,
      'paymentDetails': paymentDetails,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'transactionId': transactionId,
      'errorMessage': errorMessage,
    };
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'orderId': orderId,
      'amount': amount,
      'currency': currency,
      'status': status.toString().split('.').last,
      'paymentMethod': paymentMethod,
      'paymentDetails': paymentDetails,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': updatedAt != null ? Timestamp.fromDate(updatedAt!) : null,
      'transactionId': transactionId,
      'errorMessage': errorMessage,
    };
  }

  PaymentModel copyWith({
    String? id,
    String? userId,
    String? orderId,
    double? amount,
    String? currency,
    PaymentStatus? status,
    String? paymentMethod,
    Map<String, dynamic>? paymentDetails,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? transactionId,
    String? errorMessage,
  }) {
    return PaymentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      orderId: orderId ?? this.orderId,
      amount: amount ?? this.amount,
      currency: currency ?? this.currency,
      status: status ?? this.status,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      transactionId: transactionId ?? this.transactionId,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
