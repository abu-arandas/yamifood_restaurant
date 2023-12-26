import '/exports.dart';

class ReviewModel {
  final String name, review;
  final DateTime date;

  ReviewModel({required this.name, required this.review, required this.date});

  factory ReviewModel.fromJson(DocumentSnapshot doc) => ReviewModel(
        name: doc['name'],
        review: doc['review'],
        date: (doc['date'] as Timestamp).toDate(),
      );

  Map<String, dynamic> toJson() => {'name': name, 'review': review, 'date': date};
}
