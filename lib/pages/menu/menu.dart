import '/exports.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Menu',
      body: StreamBuilder<QuerySnapshot>(
        stream: categoryCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final data = snapshot.data!.docs;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final singleCategory = CategoryModel(
                    id: data[index].id,
                    name: data[index]['name'],
                    subcategory: data[index]['subcategory']);

                return CategoryContainer(
                    text: singleCategory.name,
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                Category(categoryModel: singleCategory))));
              },
            );
          } else {
            return waitContainer();
          }
        },
      ),
    );
  }
}
