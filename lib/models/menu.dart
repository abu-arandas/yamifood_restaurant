class CategoryModel {
  CategoryModel(
      {required this.id, required this.name, required this.subcategory});

  String id, name;
  List<ProductModel> subcategory;
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

List<CategoryModel> categorys = [
  // Drinks
  CategoryModel(
    id: '1',
    name: 'Drink',
    subcategory: [
      ProductModel(
        name: 'Special Drinks 1',
        description: 'Sed id magna vitae eros sagittis euismod.',
        price: 7.79,
        image: 'asset/products/img-01.jpg',
      ),
      ProductModel(
        name: 'Special Drinks 2',
        description: 'Sed id magna vitae eros sagittis euismod.',
        price: 9.79,
        image: 'asset/products/img-02.jpg',
      ),
      ProductModel(
        name: 'Special Drinks 3',
        description: 'Sed id magna vitae eros sagittis euismod.',
        price: 10.79,
        image: 'asset/products/img-03.jpg',
      ),
    ],
  ),

  // Launchs
  CategoryModel(
    id: '2',
    name: 'Launch',
    subcategory: [
      ProductModel(
        name: 'Special Launchs 1',
        description: 'Sed id magna vitae eros sagittis euismod.',
        price: 15.79,
        image: 'asset/products/img-04.jpg',
      ),
      ProductModel(
        name: 'Special Launchs 2',
        description: 'Sed id magna vitae eros sagittis euismod.',
        price: 18.79,
        image: 'asset/products/img-05.jpg',
      ),
      ProductModel(
        name: 'Special Launchs 3',
        description: 'Sed id magna vitae eros sagittis euismod.',
        price: 20.79,
        image: 'asset/products/img-06.jpg',
      ),
    ],
  ),

  // Dinners
  CategoryModel(
    id: '3',
    name: 'Dinner',
    subcategory: [
      ProductModel(
        name: 'Special Dinners 1',
        description: 'Sed id magna vitae eros sagittis euismod.',
        price: 25.79,
        image: 'asset/products/img-07.jpg',
      ),
      ProductModel(
        name: 'Special Dinners 2',
        description: 'Sed id magna vitae eros sagittis euismod.',
        price: 22.79,
        image: 'asset/products/img-08.jpg',
      ),
      ProductModel(
        name: 'Special Dinners 3',
        description: 'Sed id magna vitae eros sagittis euismod.',
        price: 24.79,
        image: 'asset/products/img-09.jpg',
      ),
    ],
  ),
];
