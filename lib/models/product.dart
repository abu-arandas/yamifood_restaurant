import '/exports.dart';

class ProductModel {
  String id, name, description, image;
  List<String> categoryName;
  double price;
  int cartQuantity;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.categoryName,
    required this.price,
    required this.image,
    this.cartQuantity = 0,
  });

  factory ProductModel.fromJson(DocumentSnapshot data) => ProductModel(
        id: data.id,
        name: data['name'],
        description: data['description'],
        categoryName: List.generate(
          data['categoryName'].length,
          (index) => data['categoryName'][index].toString(),
        ),
        price: data['price'],
        image: data['image'],
        cartQuantity: data['cartQuantity'],
      );

  factory ProductModel.fromMap(Map data) => ProductModel(
        id: data['name'],
        name: data['name'],
        description: data['description'],
        categoryName: List.generate(
          data['categoryName'].length,
          (index) => data['categoryName'][index].toString(),
        ),
        price: data['price'],
        image: data['image'],
        cartQuantity: data['cartQuantity'],
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'categoryName': categoryName,
        'price': price,
        'image': image,
        'cartQuantity': cartQuantity,
      };
}
/*
List<ProductModel> productsData = [
  // Drinks
  ProductModel(
    id: '1',
    name: 'Special Drinks 1',
    description: lorem,
    categoryName: ['1'],
    price: 7.79,
    image:
        'https://firebasestorage.googleapis.com/v0/b/yamifood-restaurants-app.appspot.com/o/img-01.jpg?alt=media&token=eacb44f6-efb4-472c-9c81-0938b374fa0f',
  ),
  ProductModel(
      id: '2',
      name: 'Special Drinks 2',
      description: lorem,
      categoryName: ['1'],
      price: 9.79,
      image:
          'https://firebasestorage.googleapis.com/v0/b/yamifood-restaurants-app.appspot.com/o/img-02.jpg?alt=media&token=eacb44f6-efb4-472c-9c81-0938b374fa0f'),
  ProductModel(
      id: '3',
      name: 'Special Drinks 3',
      description: lorem,
      categoryName: ['1'],
      price: 10.79,
      image:
          'https://firebasestorage.googleapis.com/v0/b/yamifood-restaurants-app.appspot.com/o/img-03.jpg?alt=media&token=eacb44f6-efb4-472c-9c81-0938b374fa0f'),

  // Launchs
  ProductModel(
      id: '4',
      name: 'Special Launchs 1',
      description: lorem,
      categoryName: ['2'],
      price: 15.79,
      image:
          'https://firebasestorage.googleapis.com/v0/b/yamifood-restaurants-app.appspot.com/o/img-04.jpg?alt=media&token=eacb44f6-efb4-472c-9c81-0938b374fa0f'),
  ProductModel(
      id: '5',
      name: 'Special Launchs 2',
      description: lorem,
      categoryName: ['2'],
      price: 18.79,
      image:
          'https://firebasestorage.googleapis.com/v0/b/yamifood-restaurants-app.appspot.com/o/img-05.jpg?alt=media&token=eacb44f6-efb4-472c-9c81-0938b374fa0f'),
  ProductModel(
      id: '6',
      name: 'Special Launchs 3',
      description: lorem,
      categoryName: ['2'],
      price: 20.79,
      image:
          'https://firebasestorage.googleapis.com/v0/b/yamifood-restaurants-app.appspot.com/o/img-06.jpg?alt=media&token=eacb44f6-efb4-472c-9c81-0938b374fa0f'),

  // Dinners
  ProductModel(
      id: '7',
      name: 'Special Dinners 1',
      description: lorem,
      categoryName: ['3'],
      price: 25.79,
      image:
          'https://firebasestorage.googleapis.com/v0/b/yamifood-restaurants-app.appspot.com/o/img-07.jpg?alt=media&token=eacb44f6-efb4-472c-9c81-0938b374fa0f'),
  ProductModel(
      id: '8',
      name: 'Special Dinners 2',
      description: lorem,
      categoryName: ['3'],
      price: 22.79,
      image:
          'https://firebasestorage.googleapis.com/v0/b/yamifood-restaurants-app.appspot.com/o/img-08.jpg?alt=media&token=eacb44f6-efb4-472c-9c81-0938b374fa0f'),
  ProductModel(
      id: '9',
      name: 'Special Dinners 3',
      description: lorem,
      categoryName: ['3'],
      price: 24.79,
      image:
          'https://firebasestorage.googleapis.com/v0/b/yamifood-restaurants-app.appspot.com/o/img-09.jpg?alt=media&token=eacb44f6-efb4-472c-9c81-0938b374fa0f'),
];
*/