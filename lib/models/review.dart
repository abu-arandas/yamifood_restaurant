import '/exports.dart';

class ReviewModel {
  final String name;
  final String address;
  final String review;
  final DateTime date;

  ReviewModel({
    required this.name,
    required this.address,
    required this.review,
    required this.date,
  });

  factory ReviewModel.fromJson(DocumentSnapshot doc) {
    return ReviewModel(
      name: doc['name'],
      address: doc['address'],
      review: doc['review'],
      date: (doc['date'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address,
        'review': review,
        'date': date,
      };
}
