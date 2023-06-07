import '/exports.dart';

class OrderModel {
  String id;
  String customerEmail;
  DateTime startTime;
  String? driverEmail;
  List<ProductModel> products;
  DateTime? endTime;
  String progress;

  OrderModel({
    required this.id,
    required this.customerEmail,
    required this.startTime,
    this.driverEmail,
    required this.products,
    this.endTime,
    required this.progress,
  });

  factory OrderModel.fromJson(DocumentSnapshot data) => OrderModel(
        id: data.id,
        customerEmail: data['customerEmail'],
        startTime: (data['startTime'] as Timestamp).toDate(),
        driverEmail: data['driverEmail'],
        products: List.generate(
          data['products'].length,
          (index) => ProductModel.fromMap(data['products'][index]),
        ),
        endTime: data['endTime'] != null ? (data['endTime'] as Timestamp).toDate() : null,
        progress: data['progress'],
      );

  Map<String, dynamic> toJson() => {
        'customerEmail': customerEmail,
        'startTime': startTime,
        'driverEmail': driverEmail,
        'products': List.generate(products.length, (index) => products[index].toJson()),
        'endTime': endTime,
        'progress': progress,
      };
}
