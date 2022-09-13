class CategoryModel {
  CategoryModel(
      {required this.id, required this.name, required this.subcategory});

  String id, name;
  List subcategory;
}

class ProductModel {
  String name, description, image;
  double price;

  ProductModel({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
  });
}

List<ProductModel> favorite = [];
List<ProductModel> cart = [];
