import '/exports.dart';

class CategoryModel {
  String id, name, image;

  CategoryModel({required this.id, required this.name, required this.image});

  factory CategoryModel.fromJson(DocumentSnapshot data) =>
      CategoryModel(id: data.id, name: data['name'], image: data['image']);

  Map<String, dynamic> toJson() => {'name': name, 'image': image};
}
/*
List<CategoryModel> categorys = [
  // Drinks
  CategoryModel(
    id: '1',
    name: 'Drink',
    image:
        'https://firebasestorage.googleapis.com/v0/b/yamifood-restaurants-app.appspot.com/o/drink.jpg?alt=media&token=55f0607c-db2e-4201-a1ff-5ef79987534a',
  ),

  // Launchs
  CategoryModel(
    id: '2',
    name: 'Launch',
    image:
        'https://firebasestorage.googleapis.com/v0/b/yamifood-restaurants-app.appspot.com/o/launch.jpg?alt=media&token=1748a736-7e10-4c83-8c8a-c0126e84e02d',
  ),

  // Dinners
  CategoryModel(
    id: '3',
    name: 'Dinner',
    image:
        'https://firebasestorage.googleapis.com/v0/b/yamifood-restaurants-app.appspot.com/o/dinner.jpg?alt=media&token=b139e02f-c540-4d5a-9221-0f3a69062776',
  ),
];
*/