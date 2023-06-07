// ignore_for_file: depend_on_referenced_packages, prefer_collection_literals

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

  Completer<GoogleMapController> mapController = Completer();

  @override
  void initState() {
    super.initState();

    auth.authStateChanges().listen((event) {
      if (event == null) {
        page(const Home());
      }
    });
  }

  @override
  void dispose() {
    mapController = Completer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomerScaf(
      pageName: 'Profile',
      body: StreamBuilder<UserModel>(
        stream: UserServices.instance.user(auth.currentUser!.email),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            pickedImage == null
                ? image = MemoryImage(base64Decode(snapshot.data!.image))
                : image = FileImage(File(pickedImage!.path));

            TextEditingController firstNameController =
                TextEditingController(text: snapshot.data!.name['firstName']);
            TextEditingController lastNameController =
                TextEditingController(text: snapshot.data!.name['lastName']);
            PhoneController phoneController = PhoneController(snapshot.data!.phone);
            LatLng? address = snapshot.data!.address == null
                ? null
                : LatLng(
                    snapshot.data!.address!.latitude,
                    snapshot.data!.address!.longitude,
                  );

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
                            pickedImage =
                                await ImagePicker().pickImage(source: ImageSource.gallery);
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
                        child: GoogleMap(
                          onMapCreated: (controller) {
                            if (!mapController.isCompleted) {
                              mapController.complete(controller);
                            }
                          },
                          onCameraMove: (position) => setState(() {
                            address = LatLng(position.target.latitude, position.target.longitude);

                            snapshot.data!.address =
                                GeoPoint(position.target.latitude, position.target.longitude);
                          }),
                          initialCameraPosition: CameraPosition(target: address!, zoom: 15),
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          scrollGesturesEnabled: true,
                          zoomGesturesEnabled: true,
                          gestureRecognizers: Set()
                            ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
                          markers: {
                            Marker(
                              markerId: const MarkerId('My Location'),
                              position: address,
                            ),
                          },
                        ),
                      ),
                    ),
                    SizedBox(height: dPadding),

                    // Button
                    BootstrapButton(
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
                              'name': {
                                'firstName': firstNameController.text,
                                'lastName': lastNameController.text
                              },
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
          } else {
            return waitContainer();
          }
        },
      ),
    );
  }
}
