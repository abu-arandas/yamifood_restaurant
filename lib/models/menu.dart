import '../exports.dart';

class CategoryModel {
  CategoryModel(
      {required this.name, required this.icon, required this.subcategory});

  String name;
  IconData icon;
  List<ProductModel> subcategory;
}

class ProductModel {
  String name, description, price, image;
  bool isFavorite, inCart;

  ProductModel({
    required this.name,
    required this.description,
    required this.price,
    required this.image,
    required this.isFavorite,
    required this.inCart,
  });
}

List<CategoryModel> category = [
  CategoryModel(
    name: 'Drink',
    icon: FontAwesomeIcons.champagneGlasses,
    subcategory: [
      ProductModel(
        name: 'Special Drinks 1',
        description: 'Sed id magna vitae eros sagittis euismod.',
        price: '7.79',
        image: 'asset/products/img-01.jpg',
        isFavorite: false,
        inCart: false,
      ),
      ProductModel(
        name: 'Special Drinks 2',
        description: 'Sed id magna vitae eros sagittis euismod.',
        price: '9.79',
        image: 'asset/products/img-02.jpg',
        isFavorite: false,
        inCart: false,
      ),
      ProductModel(
        name: 'Special Drinks 3',
        description: 'Sed id magna vitae eros sagittis euismod.',
        price: '10.79',
        image: 'asset/products/img-03.jpg',
        isFavorite: false,
        inCart: false,
      )
    ],
  ),
  CategoryModel(
    name: 'Launch',
    icon: FontAwesomeIcons.bowlFood,
    subcategory: [
      ProductModel(
        name: 'Special Lunch 1',
        description: 'Sed id magna vitae eros sagittis euismod.',
        price: '15.79',
        image: 'asset/products/img-04.jpg',
        isFavorite: false,
        inCart: false,
      ),
      ProductModel(
        name: 'Special Lunch 2',
        description: 'Sed id magna vitae eros sagittis euismod.',
        price: '18.79',
        image: 'asset/products/img-05.jpg',
        isFavorite: false,
        inCart: false,
      ),
      ProductModel(
        name: 'Special Lunch 3',
        description: 'Sed id magna vitae eros sagittis euismod.',
        price: '20.79',
        image: 'asset/products/img-06.jpg',
        isFavorite: false,
        inCart: false,
      )
    ],
  ),
  CategoryModel(
      name: 'Dinner',
      icon: FontAwesomeIcons.plateWheat,
      subcategory: [
        ProductModel(
          name: 'Special Dinner 1',
          description: 'Sed id magna vitae eros sagittis euismod.',
          price: '25.79',
          image: 'asset/products/img-07.jpg',
          isFavorite: false,
          inCart: false,
        ),
        ProductModel(
          name: 'Special Dinner 2',
          description: 'Sed id magna vitae eros sagittis euismod.',
          price: '22.79',
          image: 'asset/products/img-08.jpg',
          isFavorite: false,
          inCart: false,
        ),
        ProductModel(
          name: 'Special Dinner 3',
          description: 'Sed id magna vitae eros sagittis euismod.',
          price: '24.79',
          image: 'asset/products/img-09.jpg',
          isFavorite: false,
          inCart: false,
        )
      ]),
];

List<ProductModel> favorite = [];
List<ProductModel> cart = [];
