import '/exports.dart';

class CustomerMenuPage extends StatelessWidget {
  const CustomerMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomerScaf(
      pageName: 'Our Menu',
      body: Column(
        children: [
          const CustomerMenu(),
          Container(
            color: transparent.withOpacity(0.25),
            child: const OurTeam(),
          ),
        ],
      ),
    );
  }
}

class CustomerMenu extends StatefulWidget {
  const CustomerMenu({super.key});

  @override
  State<CustomerMenu> createState() => _CustomerMenuState();
}

class _CustomerMenuState extends State<CustomerMenu> {
  Stream<List<ProductModel>> productsStream = ProductServices.instance.products();
  String categoryId = '';

  @override
  Widget build(BuildContext context) {
    return BootstrapContainer(
      padding: EdgeInsets.all(webScreen(context) ? dPadding * 3 : dPadding),
      children: [
        BootstrapHeading.h2(text: 'Our Products', color: primary),

        // Categories
        StreamBuilder<List<CategoryModel>>(
          stream: CategoryServices.instance.categories(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return Container(
                width: double.maxFinite,
                height: 50,
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: dPadding / 2),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  children: [
                    categoryWidget(CategoryModel(id: '', name: 'All', image: '')),
                    for (CategoryModel category in snapshot.data!) categoryWidget(category)
                  ],
                ),
              );
            } else {
              return waitContainer();
            }
          },
        ),

        // Products
        StreamBuilder<List<ProductModel>>(
          stream: productsStream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<ProductModel> products = categoryId == ''
                  ? snapshot.data!
                  : snapshot.data!
                      .where((element) => element.categoryName.contains(categoryId))
                      .toList();

              return BootstrapRow(
                children: List.generate(
                  products.length,
                  (index) => BootstrapCol(
                    sizes: 'col-lg-4 col-md-6 col-sm-12',
                    child: ProductWidget(productData: products[index]),
                  ),
                ),
              );
            } else {
              return waitContainer();
            }
          },
        ),
      ],
    );
  }

  Widget categoryWidget(CategoryModel category) {
    return Padding(
      padding: EdgeInsets.only(right: dPadding),
      child: ElevatedButton(
        onPressed: () => setState(() => categoryId = category.id),
        style: ButtonStyle(
          shape: MaterialStatePropertyAll(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.5)),
          ),
          padding: MaterialStatePropertyAll(EdgeInsets.all(dPadding)),
          backgroundColor: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.hovered) ||
                    states.contains(MaterialState.dragged) ||
                    states.contains(MaterialState.pressed) ||
                    categoryId == category.id
                ? primary
                : white,
          ),
          foregroundColor: MaterialStateProperty.resolveWith(
            (states) => states.contains(MaterialState.hovered) ||
                    states.contains(MaterialState.dragged) ||
                    states.contains(MaterialState.pressed) ||
                    categoryId == category.id
                ? white
                : primary,
          ),
        ),
        child: Text(category.name),
      ),
    );
  }
}
