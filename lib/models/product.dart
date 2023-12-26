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