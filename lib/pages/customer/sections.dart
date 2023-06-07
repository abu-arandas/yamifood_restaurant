// ignore_for_file: prefer_collection_literals

import '/exports.dart';

class CustomerReviews extends StatefulWidget {
  const CustomerReviews({super.key});

  @override
  State<CustomerReviews> createState() => _CustomerReviewsState();
}

class _CustomerReviewsState extends State<CustomerReviews> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: auth.authStateChanges(),
      builder: (context, authSnapshot) {
        return StreamBuilder<List<ReviewModel>>(
          stream: reviewsCollection
              .snapshots()
              .map((query) => query.docs.map((item) => ReviewModel.fromJson(item)).toList()),
          builder: (context, reviewsSnapshot) {
            if (reviewsSnapshot.hasData) {
              reviewsSnapshot.data!.sort((a, b) => a.date.compareTo(b.date));

              return BootstrapContainer(
                padding: EdgeInsets.all(webScreen(context) ? dPadding * 3 : dPadding),
                center: true,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      BootstrapHeading.h2(text: 'Customers Reviews', color: primary),
                      if (authSnapshot.hasData)
                        IconButton(
                          onPressed: () => showDialog(
                            context: Get.context!,
                            builder: (BuildContext context) {
                              return BootstrapModal(
                                dismissble: true,
                                title: 'Create a new Review',
                                content: Form(
                                  key: formKey,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Name
                                      TextInputFeild(
                                        text: 'Name',
                                        color: grey,
                                        controller: nameController,
                                      ),
                                      SizedBox(height: dPadding),

                                      // Review
                                      TextInputFeild(
                                        text: 'Review',
                                        color: grey,
                                        controller: reviewController,
                                        keyboardType: TextInputType.multiline,
                                      ),
                                      SizedBox(height: dPadding),
                                    ],
                                  ),
                                ),
                                actions: [
                                  BootstrapButton(
                                    onPressed: () async {
                                      if (formKey.currentState!.validate()) {
                                        try {
                                          await usersCollection.doc().get().then(
                                                (value) async => firestore
                                                    .collection('reviews')
                                                    .doc()
                                                    .set(ReviewModel(
                                                      name: nameController.text,
                                                      address: await AddressServices.instance
                                                          .locationAddress(
                                                              value['address'].latitude,
                                                              value['address'].longitude),
                                                      review: reviewController.text,
                                                      date: DateTime.now(),
                                                    ).toJson())
                                                    .then((value) => succesSnackBar('Added'))
                                                    .then((value) => page(const CustomerHome())),
                                              );
                                        } on FirebaseException catch (error) {
                                          errorSnackBar(error.message!);
                                        }
                                      }
                                    },
                                    child: const Text('Submit'),
                                  ),
                                ],
                              );
                            },
                          ),
                          icon: const Icon(FontAwesomeIcons.plus, size: 18),
                        ),
                    ],
                  ),
                  for (var review in reviewsSnapshot.data!)
                    BootstrapCol(
                      sizes: 'col-lg-4 col-md-6 col-sm-12',
                      child: Padding(
                        padding: EdgeInsets.all(dPadding).copyWith(bottom: 0),
                        child: ListTile(
                          tileColor: secondary.withOpacity(0.5),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.5)),

                          // Name
                          title: BootstrapHeading.h4(text: review.name),

                          // Address
                          subtitle: Padding(
                            padding: EdgeInsets.all(dPadding / 2).copyWith(bottom: 0),
                            child: BootstrapParagraph(text: review.address),
                          ),

                          // Show All
                          trailing: IconButton(
                            onPressed: () => showDialog(
                              context: Get.context!,
                              builder: (BuildContext context) {
                                return BootstrapModal(
                                  dismissble: true,
                                  title: 'Review Information',
                                  content: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      // Name
                                      Padding(
                                        padding: EdgeInsets.all(dPadding / 2).copyWith(bottom: 0),
                                        child: BootstrapHeading.h4(text: review.name),
                                      ),

                                      // Address
                                      BootstrapParagraph(text: review.address),

                                      // Divider
                                      Container(
                                        width: 100,
                                        height: 1,
                                        margin: EdgeInsets.all(dPadding / 2),
                                        color: primary,
                                      ),

                                      // Review
                                      BootstrapParagraph(
                                        text: review.review,
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                            icon: Icon(FontAwesomeIcons.info, color: primary, size: 18),
                          ),
                        ),
                      ),
                    ),
                ],
              );
            } else {
              return waitContainer();
            }
          },
        );
      },
    );
  }
}

class OurTeam extends StatelessWidget {
  const OurTeam({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<TeamModel>>(
      stream: firestore
          .collection('teams')
          .snapshots()
          .map((query) => query.docs.map((item) => TeamModel.fromJson(item)).toList()),
      builder: (context, teamsSnapshot) {
        return BootstrapContainer(
          padding: EdgeInsets.all(webScreen(context) ? dPadding * 3 : dPadding),
          children: [
            // Title & Add
            BootstrapHeading.h2(text: 'Our Team', color: primary),

            // Team Members
            if (teamsSnapshot.hasData)
              BootstrapRow(
                children: List.generate(
                  teamsSnapshot.data!.length,
                  (index) => BootstrapCol(
                    sizes: 'col-lg-4 col-md-6 col-sm-12',
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: double.maxFinite,
                            height: 200,
                            padding: EdgeInsets.all(dPadding),
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: MemoryImage(base64Decode(teamsSnapshot.data![index].image)),
                                fit: BoxFit.fill,
                                colorFilter: overlay,
                              ),
                              borderRadius: BorderRadius.circular(12.5),
                              boxShadow: [blackShadow],
                            ),
                          ),
                          BootstrapHeading.h4(text: teamsSnapshot.data![index].name),
                          BootstrapParagraph(text: teamsSnapshot.data![index].job),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                onPressed: () async =>
                                    await launchUrl(Uri.parse(teamsSnapshot.data![index].facebook)),
                                icon: const Icon(
                                  FontAwesomeIcons.facebook,
                                  size: 18,
                                ),
                              ),
                              IconButton(
                                onPressed: () async => await launchUrl(
                                    Uri.parse(teamsSnapshot.data![index].instagram)),
                                icon: const Icon(
                                  FontAwesomeIcons.instagram,
                                  size: 18,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class ContactUs extends StatefulWidget {
  const ContactUs({super.key});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  Completer<GoogleMapController> mapController = Completer();

  @override
  void dispose() {
    mapController = Completer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BootstrapContainer(
      padding: EdgeInsets.all(webScreen(context) ? dPadding * 3 : dPadding),
      children: [
        // Contact Information
        BootstrapCol(
          sizes: 'col-lg-6 col-md-6 col-sm-12',
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BootstrapHeading.h2(text: 'Contact Informations', color: primary),
              link(
                  text: App.phone.international,
                  function: () async =>
                      await launchUrl(Uri.parse('tel:${App.phone.international}'))),
              link(
                  text: App.email,
                  function: () async => await launchUrl(
                        Uri.parse('mailto:e.aeandas@gmail.com?subject=${App.name}&body= '),
                      )),
              link(
                  text: App.address['name'],
                  function: () async => await launchUrl(
                        Uri.parse(
                            'https://maps.google.com/?q=${App.address['latitude']},${App.address['longitude']}'),
                      )),
            ],
          ),
        ),

        // Open Hours
        BootstrapCol(
          sizes: 'col-lg-6 col-md-6 col-sm-12',
          child: Container(
            margin: webScreen(context) ? EdgeInsets.zero : EdgeInsets.only(top: dPadding),
            padding: EdgeInsets.all(dPadding),
            decoration: BoxDecoration(
              color: secondary,
              boxShadow: [primaryShadow],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const BootstrapHeading.h2(text: 'Opening Hours'),
                Padding(
                  padding: EdgeInsets.all(dPadding),
                  child: Divider(color: primary, thickness: 1),
                ),
                BootstrapRow(
                  children: [
                    BootstrapCol(
                      sizes: 'col-6',
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BootstrapHeading.h4(text: 'Sat - Wed'),
                          BootstrapHeading.h5(text: '8:00\n22:00'),
                        ],
                      ),
                    ),
                    BootstrapCol(
                      sizes: 'col-6',
                      child: const Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BootstrapHeading.h4(text: 'Thu - Fri'),
                          BootstrapHeading.h5(text: '8:00\n24:00'),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),

        // Map
        BootstrapCol(
          sizes: 'col-12',
          child: Container(
            height: 300,
            margin: EdgeInsets.only(top: dPadding * 2),
            child: GoogleMap(
              onMapCreated: (controller) {
                if (!mapController.isCompleted) {
                  mapController.complete(controller);
                }
              },
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  App.address['latitude'],
                  App.address['longitude'],
                ),
                zoom: 15,
              ),
              scrollGesturesEnabled: true,
              zoomGesturesEnabled: true,
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              gestureRecognizers: Set()
                ..add(Factory<PanGestureRecognizer>(() => PanGestureRecognizer())),
              markers: {
                Marker(
                  markerId: const MarkerId('My Location'),
                  position: LatLng(
                    App.address['latitude'],
                    App.address['longitude'],
                  ),
                ),
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget link({required String text, required void Function()? function}) {
    return TextButton(
      onPressed: function,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith((states) =>
            states.contains(MaterialState.hovered) ||
                    states.contains(MaterialState.pressed) ||
                    states.contains(MaterialState.focused)
                ? primary
                : white),
      ),
      child: BootstrapParagraph(text: text),
    );
  }
}
