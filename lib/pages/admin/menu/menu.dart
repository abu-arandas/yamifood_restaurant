import '/exports.dart';

class AdminMenu extends StatelessWidget {
  const AdminMenu({super.key});

  @override
  Widget build(BuildContext context) => AdminScaf(
        body: Column(
          children: [
            // Categories
            Padding(
              padding: EdgeInsets.all(dPadding).copyWith(top: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Categories', style: TextStyle(fontSize: h2)),
                  ElevatedButton(
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
                  return FB5Row(
                    children: List.generate(
                      snapshot.data!.length,
                      (index) => FB5Col(
                        classNames: 'col-lg-4 col-md-6 col-sm-12 col-xs-12 p-3',
                        child: Container(
                          width: double.maxFinite,
                          constraints: const BoxConstraints(minHeight: 150),
                          padding: EdgeInsets.all(dPadding),
                          alignment: Alignment.topRight,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(
                                  base64Decode(snapshot.data![index].image)),
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
                              Text(snapshot.data![index].name,
                                  style: TextStyle(fontSize: h3)),

                              // Buttons
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  IconButton(
                                    onPressed: () => page(CategoryEdit(
                                        category: snapshot.data![index])),
                                    icon: Icon(
                                      Icons.edit,
                                      color: white,
                                      size: 18,
                                      shadows: [blackShadow],
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () => CategoryServices.instance
                                        .deleteCategory(
                                            snapshot.data![index].id),
                                    icon: Icon(
                                      Icons.delete,
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

            // Products
            Padding(
              padding: EdgeInsets.all(dPadding).copyWith(top: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text('Products', style: TextStyle(fontSize: h2)),
                  ElevatedButton(
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
                  return FB5Row(
                    children: List.generate(
                      snapshot.data!.length,
                      (index) => FB5Col(
                        classNames: 'col-lg-4 col-md-6 col-sm-12 col-xs-12',
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
                                    image: MemoryImage(base64Decode(
                                        snapshot.data![index].image)),
                                    fit: BoxFit.fill,
                                    colorFilter: overlay,
                                  ),
                                  borderRadius: BorderRadius.circular(12.5),
                                  boxShadow: [blackShadow],
                                ),
                                child: Text(snapshot.data![index].name,
                                    style: TextStyle(fontSize: h2)),
                              ),

                              // Price
                              Padding(
                                padding: EdgeInsets.all(dPadding)
                                    .copyWith(bottom: 0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text('Price :',
                                        style: TextStyle(fontSize: h3)),
                                    SizedBox(width: dPadding / 2),
                                    Text('${snapshot.data![index].price} JD')
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
                                          .copyWith(
                                              top: dPadding / 2, bottom: 0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text('Category :',
                                              style: TextStyle(fontSize: h3)),
                                          SizedBox(width: dPadding / 2),
                                          Wrap(
                                            children: List.generate(
                                              snapshot.data![index].categoryName
                                                  .length,
                                              (indexData) => Container(
                                                margin: EdgeInsets.only(
                                                    left: dPadding / 2),
                                                padding: EdgeInsets.all(
                                                    dPadding / 2),
                                                decoration: BoxDecoration(
                                                  border: Border.all(
                                                      color: primary),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12.5),
                                                ),
                                                child: Text(
                                                  categorySnapshot.data!
                                                      .singleWhere((element) =>
                                                          element.id ==
                                                          snapshot.data![index]
                                                                  .categoryName[
                                                              indexData])
                                                      .name,
                                                  style: TextStyle(
                                                      fontSize: h2,
                                                      color: primary),
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
                                padding: EdgeInsets.all(dPadding)
                                    .copyWith(top: dPadding / 2, bottom: 0),
                                child: Text(snapshot.data![index].description),
                              ),

                              // Buttons
                              Container(
                                padding: EdgeInsets.all(dPadding),
                                child: Row(
                                  children: [
                                    // Edit
                                    ElevatedButton(
                                      onPressed: () => page(ProductEdit(
                                          product: snapshot.data![index])),
                                      child: const Text('Edit'),
                                    ),
                                    SizedBox(width: dPadding),

                                    // Delete
                                    ElevatedButton(
                                      onPressed: () => ProductServices.instance
                                          .deleteProduct(
                                              snapshot.data![index].id),
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: danger),
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
          ],
        ),
      );
}
