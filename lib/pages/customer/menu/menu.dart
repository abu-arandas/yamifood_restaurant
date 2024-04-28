import '/exports.dart';

class CustomerMenuPage extends StatelessWidget {
  const CustomerMenuPage({super.key});

  @override
  Widget build(BuildContext context) => CustomerScaf(
        pageName: 'Our Menu',
        body: Column(
          children: [
            const CustomerMenu(),
            Container(
              width: double.maxFinite,
              alignment: Alignment.center,
              color: transparent.withOpacity(0.25),
              child: const OurTeam(),
            ),
          ],
        ),
      );
}

class CustomerMenu extends StatefulWidget {
  const CustomerMenu({super.key});

  @override
  State<CustomerMenu> createState() => _CustomerMenuState();
}

class _CustomerMenuState extends State<CustomerMenu> {
  Stream<List<ProductModel>> productsStream =
      ProductServices.instance.products();
  String categoryId = '';

  @override
  Widget build(BuildContext context) => FB5Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: dPadding * (webScreen(context) ? 3 : 1)),

            Padding(
              padding: EdgeInsets.all(dPadding),
              child: Text(
                'Our Products',
                style: title(context: context, color: primary),
              ),
            ),

            // Categories
            Padding(
              padding: EdgeInsets.all(dPadding),
              child: StreamBuilder<List<CategoryModel>>(
                stream: CategoryServices.instance.categories(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          categoryWidget(
                              CategoryModel(id: '', name: 'All', image: '')),
                          for (CategoryModel category in snapshot.data!)
                            categoryWidget(category)
                        ],
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return waitContainer();
                  } else {
                    return Container();
                  }
                },
              ),
            ),

            // Products
            StreamBuilder<List<ProductModel>>(
              stream: productsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ProductModel> products = categoryId == ''
                      ? snapshot.data!
                      : snapshot.data!
                          .where((element) =>
                              element.categoryName.contains(categoryId))
                          .toList();

                  return FB5Row(
                    children: List.generate(
                      products.length,
                      (index) => FB5Col(
                        classNames: 'col-lg-4 col-md-6 col-sm-12 col-xs-12',
                        child: ProductWidget(productData: products[index]),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return waitContainer();
                } else {
                  return Container();
                }
              },
            ),

            SizedBox(height: dPadding * (webScreen(context) ? 3 : 1)),
          ],
        ),
      );

  Widget categoryWidget(CategoryModel category) => Padding(
        padding: EdgeInsets.only(right: dPadding),
        child: categoryId == category.id
            ? ElevatedButton(
                onPressed: () => setState(() => categoryId = category.id),
                child: Text(category.name),
              )
            : OutlinedButton(
                onPressed: () => setState(() => categoryId = category.id),
                child: Text(category.name),
              ),
      );
}
