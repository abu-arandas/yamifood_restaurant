import '/exports.dart';

class CategoryModel {
  String id, name, image;

  CategoryModel({required this.id, required this.name, required this.image});

  factory CategoryModel.fromJson(DocumentSnapshot data) =>
      CategoryModel(id: data.id, name: data['name'], image: data['image']);

  Map<String, dynamic> toJson() => {'name': name, 'image': image};
}