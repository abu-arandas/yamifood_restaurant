// ignore_for_file: depend_on_referenced_packages

import '/exports.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  final formKey = GlobalKey<FormState>();
  XFile? pickedImage;
  ImageProvider? image;
  bool obscureText = true;
  LatLng? address;

  @override
  void initState() {
    super.initState();

    auth.authStateChanges().listen((event) {
      if (event == null) {
        page(const Home());

        usersCollection.doc(auth.currentUser!.email).get().then((value) => setState(
              () => address = value['address'] == null ? null : LatLng(value['address'].latitude, value['address'].longitude),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) => CustomerScaf(
        pageName: 'Profile',
        body: StreamBuilder<UserModel>(
          stream: UserServices.instance.user(auth.currentUser!.email),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              pickedImage == null ? image = MemoryImage(base64Decode(snapshot.data!.image)) : image = FileImage(File(pickedImage!.path));

              TextEditingController firstNameController = TextEditingController(text: snapshot.data!.name.firstName);
              TextEditingController lastNameController = TextEditingController(text: snapshot.data!.name.lastName);
              PhoneController phoneController = PhoneController(snapshot.data!.phone);

              return Container(
                padding: EdgeInsets.symmetric(vertical: dPadding * 2, horizontal: dPadding),
                alignment: Alignment.center,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: EdgeInsets.all(dPadding),
                  decoration: BoxDecoration(
                    color: secondary.withOpacity(0.25),
                    borderRadius: BorderRadius.circular(12.5),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Image
                      Container(
                        width: webScreen(context) ? 200 : 150,
                        height: webScreen(context) ? 200 : 150,
                        margin: EdgeInsets.all(dPadding),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: image!,
                            fit: BoxFit.fill,
                            colorFilter: overlay,
                          ),
                          boxShadow: [primaryShadow],
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
                      SizedBox(height: dPadding),

                      // Name
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextInputFeild(
                              text: 'First Name',
                              color: white,
                              controller: firstNameController,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                          SizedBox(width: dPadding / 2),
                          Expanded(
                            child: TextInputFeild(
                              text: 'Last Name',
                              color: white,
                              controller: lastNameController,
                              keyboardType: TextInputType.name,
                              textInputAction: TextInputAction.next,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: dPadding),

                      // Phone
                      PhoneInput(text: 'Phone Number', color: white, controller: phoneController),
                      SizedBox(height: dPadding),

                      // Address
                      SizedBox(
                        height: 300,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.5),
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: address ?? LatLng(App.address['latitude'], App.address['longitude']),
                              initialZoom: 15,
                              onMapEvent: (event) => setState(() => address = event.camera.center),
                              onTap: (tapPosition, point) => setState(() => address = point),
                            ),
                            children: [
                              TileLayer(
                                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                userAgentPackageName: 'com.arandas.yamifood_restaurant',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: address ?? LatLng(App.address['latitude'], App.address['longitude']),
                                    child: const Icon(Icons.location_pin, color: Colors.red),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: dPadding),

                      // Button
                      ElevatedButton(
                        onPressed: () async {
                          if (formKey.currentState!.validate()) {
                            String imageData;

                            if (pickedImage != null) {
                              imageData = base64Encode(await pickedImage!.readAsBytes());
                            } else {
                              http.Response response = await http.get(Uri.parse(defaultImage));

                              imageData = base64Encode(response.bodyBytes);
                            }

                            UserServices.instance.updateUser(
                              email: snapshot.data!.email,
                              data: {
                                'name': {'firstName': firstNameController.text, 'lastName': lastNameController.text},
                                'image': imageData,
                                'phone': phoneController.value!,
                                'address': snapshot.data!.address,
                              },
                            );
                          }
                        },
                        child: const Text('Update'),
                      ),
                    ],
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
      );
}
