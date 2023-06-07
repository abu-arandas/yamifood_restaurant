import '/exports.dart';

class AdminCategories extends StatelessWidget {
  const AdminCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminScaf(
      body: BootstrapContainer(
        children: [
          Padding(
            padding: EdgeInsets.all(dPadding).copyWith(top: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const BootstrapHeading.h2(text: 'Categories'),
                BootstrapButton(
                  onPressed: () => page(const CategoryEdit()),
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          StreamBuilder<List<CategoryModel>>(
            stream: CategoryServices.instance.categories(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return BootstrapRow(
                  children: List.generate(
                    snapshot.data!.length,
                    (index) => BootstrapCol(
                      sizes: 'col-lg-4 col-md-6 col-sm-12',
                      child: Container(
                        width: double.maxFinite,
                        constraints: const BoxConstraints(minHeight: 150),
                        padding: EdgeInsets.all(dPadding),
                        alignment: Alignment.topRight,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: MemoryImage(base64Decode(snapshot.data![index].image)),
                            fit: BoxFit.fill,
                            colorFilter: overlay,
                          ),
                          borderRadius: BorderRadius.circular(12.5),
                          boxShadow: [blackShadow],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // -- Name
                            BootstrapHeading.h3(text: snapshot.data![index].name),

                            // Buttons
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                IconButton(
                                  onPressed: () =>
                                      page(CategoryEdit(category: snapshot.data![index])),
                                  icon: Icon(
                                    FontAwesomeIcons.pen,
                                    color: white,
                                    size: 18,
                                    shadows: [blackShadow],
                                  ),
                                ),
                                IconButton(
                                  onPressed: () => CategoryServices.instance
                                      .deleteCategory(snapshot.data![index].id),
                                  icon: Icon(
                                    FontAwesomeIcons.trash,
                                    color: danger,
                                    size: 18,
                                    shadows: [blackShadow],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              } else {
                return waitContainer();
              }
            },
          ),
        ],
      ),
    );
  }
}
