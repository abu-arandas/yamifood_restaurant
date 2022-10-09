import '/exports.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Menu',
      body: ListView.builder(
        itemCount: categorys.length,
        itemBuilder: (context, index) {
          CategoryModel singleCategory = CategoryModel(
            id: categorys[index].id,
            name: categorys[index].name,
            subcategory: categorys[index].subcategory,
          );

          return CategoryContainer(
              text: singleCategory.name,
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Category(categoryModel: singleCategory))));
        },
      ),
    );
  }
}
