// ignore_for_file: depend_on_referenced_packages

import '/exports.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class ProductEdit extends StatefulWidget {
  final ProductModel? product;
  const ProductEdit({super.key, this.product});

  @override
  State<ProductEdit> createState() => _ProductEditState();
}

class _ProductEditState extends State<ProductEdit> {
  GlobalKey<FormState> formKey = GlobalKey();
  XFile? pickedImage;
  ImageProvider? image;
  TextEditingController name = TextEditingController();
  TextEditingController price = TextEditingController();
  TextEditingController description = TextEditingController();

  List<String> selectedCategory = [];

  @override
  Widget build(BuildContext context) {
    if (widget.product != null) {
      pickedImage == null ? image = MemoryImage(base64Decode(widget.product!.image)) : image = FileImage(File(pickedImage!.path));

      name = TextEditingController(text: widget.product!.name);
      price = TextEditingController(text: widget.product!.price.toString());
      description = TextEditingController(text: widget.product!.description);
    } else {
      pickedImage == null ? image = NetworkImage(defaultImage) : image = FileImage(File(pickedImage!.path));
    }

    return AdminScaf(
      body: Container(
        width: 500,
        constraints: BoxConstraints(minHeight: screenHeight(context) * 0.75),
        alignment: Alignment.center,
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image
              Container(
                width: double.maxFinite,
                height: 200,
                margin: EdgeInsets.all(dPadding),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.5),
                  image: DecorationImage(
                    image: image!,
                    fit: BoxFit.fill,
                    colorFilter: overlay,
                  ),
                ),
                child: IconButton(
                  onPressed: () async {
                    if (pickedImage == null) {
                      pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                      setState(() {});
                    } else {
                      pickedImage = null;
                      setState(() {});
                    }
                  },
                  icon: Icon(
                    pickedImage == null ? Icons.camera : Icons.remove_circle,
                    color: white,
                    size: 18,
                  ),
                ),
              ),

              // Name
              Padding(
                padding: EdgeInsets.all(dPadding),
                child: TextInputFeild(
                  text: 'Product Name',
                  color: grey,
                  controller: name,
                  onChanged: (value) => setState(() => widget.product!.name = value),
                ),
              ),

              // Price
              Padding(
                padding: EdgeInsets.all(dPadding),
                child: TextInputFeild(
                  text: 'Product Price',
                  color: grey,
                  controller: price,
                  keyboardType: TextInputType.number,
                  onChanged: (value) => setState(() => widget.product!.price = double.parse(value)),
                ),
              ),

              // Description
              Padding(
                padding: EdgeInsets.all(dPadding),
                child: TextInputFeild(
                  text: 'Product Description',
                  color: grey,
                  controller: description,
                  keyboardType: TextInputType.text,
                  textInputAction: TextInputAction.done,
                  onChanged: (value) => setState(() => widget.product!.description = value),
                ),
              ),

              // Categories
              Padding(
                padding: EdgeInsets.all(dPadding).copyWith(top: 0),
                child: StreamBuilder<List<CategoryModel>>(
                  stream: CategoryServices.instance.categories(),
                  builder: (context, categorySnapshot) {
                    if (categorySnapshot.hasData) {
                      return MultiSelectDialogField(
                        title: const Text('Categories'),
                        items: categorySnapshot.data!.map((e) => MultiSelectItem(e.id, e.name)).toList(),
                        initialValue: widget.product!.categoryName,
                        onConfirm: (categories) {
                          for (var category in categories) {
                            if (selectedCategory.contains(category)) {
                              selectedCategory.removeWhere((element) => element == category);
                            } else {
                              selectedCategory.add(category);
                            }
                          }
                        },
                      );
                    } else if (categorySnapshot.hasError) {
                      return Center(child: Text(categorySnapshot.error.toString()));
                    } else if (categorySnapshot.connectionState == ConnectionState.waiting) {
                      return waitContainer();
                    } else {
                      return Container();
                    }
                  },
                ),
              ),

              // Button
              Container(
                padding: EdgeInsets.all(dPadding),
                child: Row(
                  children: [
                    // Edit
                    ElevatedButton(
                      onPressed: () async {
                        if (formKey.currentState!.validate()) {
                          String imageData;

                          if (pickedImage != null) {
                            imageData = base64Encode(await pickedImage!.readAsBytes());
                          } else if (widget.product != null) {
                            imageData = widget.product!.image;
                          } else {
                            http.Response response = await http.get(Uri.parse(defaultImage));

                            imageData = base64Encode(response.bodyBytes);
                          }

                          if (widget.product != null) {
                            ProductServices.instance.updateProduct(
                              ProductModel(
                                id: widget.product!.id,
                                image: imageData,
                                categoryName: selectedCategory,
                                name: name.text,
                                description: description.text,
                                price: double.parse(price.text),
                              ),
                            );
                          } else {
                            ProductServices.instance.addProduct(
                              ProductModel(
                                id: '',
                                image: imageData,
                                categoryName: selectedCategory,
                                name: name.text,
                                description: description.text,
                                price: double.parse(price.text),
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Edit'),
                    ),
                    SizedBox(width: dPadding),

                    // Delete
                    if (widget.product != null)
                      ElevatedButton(
                        onPressed: () => ProductServices.instance.deleteProduct(widget.product!.id),
                        style: ElevatedButton.styleFrom(backgroundColor: danger),
                        child: const Text('Delete'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
