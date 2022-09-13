import '/exports.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return MyScaffold(
      title: 'Menu',
      body: ListView.builder(
        itemCount: category.length,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => CategoryContainer(
          text: category[index].name,
          icon: category[index].icon,
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      Category(categoryModel: category[index]))),
        ),
      ),
    );
  }
}
