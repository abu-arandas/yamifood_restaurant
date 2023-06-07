import '/exports.dart';

class AdminProducts extends StatelessWidget {
  const AdminProducts({super.key});

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
                const BootstrapHeading.h2(text: 'Products'),
                BootstrapButton(
                  onPressed: () => page(const ProductEdit()),
                  child: const Text('Add'),
                ),
              ],
            ),
          ),
          StreamBuilder<List<ProductModel>>(
            stream: ProductServices.instance.products(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return BootstrapRow(
                  children: List.generate(
                    snapshot.data!.length,
                    (index) => BootstrapCol(
                      sizes: 'col-lg-4 col-md-6 col-sm-12',
                      child: Card(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image
                            Container(
                              width: double.maxFinite,
                              height: 150,
                              padding: EdgeInsets.all(dPadding),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: MemoryImage(base64Decode(snapshot.data![index].image)),
                                  fit: BoxFit.fill,
                                  colorFilter: overlay,
                                ),
                                borderRadius: BorderRadius.circular(12.5),
                                boxShadow: [blackShadow],
                              ),
                              child: BootstrapHeading.h3(text: snapshot.data![index].name),
                            ),

                            // Price
                            Padding(
                              padding: EdgeInsets.all(dPadding).copyWith(bottom: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  const BootstrapHeading.h3(text: 'Price :'),
                                  SizedBox(width: dPadding / 2),
                                  BootstrapParagraph(text: '${snapshot.data![index].price} JD')
                                ],
                              ),
                            ),

                            // Category
                            StreamBuilder<List<CategoryModel>>(
                              stream: CategoryServices.instance.categories(),
                              builder: (context, categorySnapshot) {
                                if (categorySnapshot.hasData) {
                                  return Padding(
                                    padding: EdgeInsets.all(dPadding)
                                        .copyWith(top: dPadding / 2, bottom: 0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        const BootstrapHeading.h3(text: 'Category :'),
                                        SizedBox(width: dPadding / 2),
                                        Wrap(
                                          children: List.generate(
                                            snapshot.data![index].categoryName.length,
                                            (indexData) => Container(
                                              margin: EdgeInsets.only(left: dPadding / 2),
                                              padding: EdgeInsets.all(dPadding / 2),
                                              decoration: BoxDecoration(
                                                border: Border.all(color: primary),
                                                borderRadius: BorderRadius.circular(12.5),
                                              ),
                                              child: BootstrapHeading.h4(
                                                text: categorySnapshot.data!
                                                    .singleWhere((element) =>
                                                        element.id ==
                                                        snapshot
                                                            .data![index].categoryName[indexData])
                                                    .name,
                                                color: primary,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  return waitContainer();
                                }
                              },
                            ),

                            // Description
                            Padding(
                              padding:
                                  EdgeInsets.all(dPadding).copyWith(top: dPadding / 2, bottom: 0),
                              child: BootstrapParagraph(text: snapshot.data![index].description),
                            ),

                            // Buttons
                            Container(
                              padding: EdgeInsets.all(dPadding),
                              child: Row(
                                children: [
                                  // Edit
                                  BootstrapButton(
                                    onPressed: () =>
                                        page(ProductEdit(product: snapshot.data![index])),
                                    child: const Text('Edit'),
                                  ),
                                  SizedBox(width: dPadding),

                                  // Delete
                                  BootstrapButton(
                                    type: BootstrapButtonType.danger,
                                    onPressed: () => ProductServices.instance
                                        .deleteProduct(snapshot.data![index].id),
                                    child: const Text('Delete'),
                                  ),
                                ],
                              ),
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
