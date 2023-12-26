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
  Stream<List<ProductModel>> productsStream = ProductServices.instance.products();
  String categoryId = '';

  @override
  Widget build(BuildContext context) => Container(
        width: maxWidth(context),
        padding: EdgeInsets.all(webScreen(context) ? dPadding * 3 : dPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Our Products', style: title(context: context, color: primary)),

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
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return waitContainer();
                } else {
                  return Container();
                }
              },
            ),

            // Products
            StreamBuilder<List<ProductModel>>(
              stream: productsStream,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<ProductModel> products =
                      categoryId == '' ? snapshot.data! : snapshot.data!.where((element) => element.categoryName.contains(categoryId)).toList();

                  return Wrap(
                    children: List.generate(
                      products.length,
                      (index) => Div(
                        lg: Col.col4,
                        md: Col.col6,
                        sm: Col.col12,
                        child: ProductWidget(productData: products[index]),
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text(snapshot.error.toString()));
                } else if (snapshot.connectionState == ConnectionState.waiting) {
                  return waitContainer();
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
      );

  Widget categoryWidget(CategoryModel category) => Padding(
        padding: EdgeInsets.only(right: dPadding),
        child: ElevatedButton(
          onPressed: () => setState(() => categoryId = category.id),
          style: ButtonStyle(
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
