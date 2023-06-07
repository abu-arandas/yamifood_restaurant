// ignore_for_file: depend_on_referenced_packages

import '/exports.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class CategoryEdit extends StatefulWidget {
  final CategoryModel? category;
  const CategoryEdit({super.key, this.category});

  @override
  State<CategoryEdit> createState() => _CategoryEditState();
}

class _CategoryEditState extends State<CategoryEdit> {
  GlobalKey<FormState> formKey = GlobalKey();
  XFile? pickedImage;
  ImageProvider? image;
  TextEditingController name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (widget.category != null) {
      pickedImage == null
          ? image = MemoryImage(base64Decode(widget.category!.image))
          : image = FileImage(File(pickedImage!.path));

      name = TextEditingController(text: widget.category!.name);
    } else {
      pickedImage == null
          ? image = NetworkImage(defaultImage)
          : image = FileImage(File(pickedImage!.path));
    }

    return AdminScaf(
      body: Column(
        children: [
          SizedBox(
            width: 500,
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
                        pickedImage == null
                            ? FontAwesomeIcons.camera
                            : FontAwesomeIcons.circleMinus,
                        color: white,
                        size: 18,
                      ),
                    ),
                  ),

                  // Name
                  Padding(
                    padding: EdgeInsets.all(dPadding),
                    child: TextInputFeild(
                      text: 'Category Name',
                      color: grey,
                      controller: name,
                    ),
                  ),

                  // Button
                  BootstrapButton(
                    onPressed: () async {
                      if (formKey.currentState!.validate()) {
                        String imageData;

                        if (pickedImage != null) {
                          imageData = base64Encode(await pickedImage!.readAsBytes());
                        } else if (widget.category != null) {
                          imageData = widget.category!.image;
                        } else {
                          http.Response response = await http.get(Uri.parse(defaultImage));

                          imageData = base64Encode(response.bodyBytes);
                        }

                        if (widget.category != null) {
                          CategoryServices.instance.updateCategory(
                            CategoryModel(
                                id: widget.category!.id, name: name.text, image: imageData),
                          );
                        } else {
                          CategoryServices.instance.addCategory(
                            CategoryModel(id: '', name: name.text, image: imageData),
                          );
                        }
                      }
                    },
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
