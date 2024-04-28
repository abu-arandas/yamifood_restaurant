import '/exports.dart';

class CustomerReviews extends StatefulWidget {
  const CustomerReviews({super.key});

  @override
  State<CustomerReviews> createState() => _CustomerReviewsState();
}

class _CustomerReviewsState extends State<CustomerReviews> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, authSnapshot) => StreamBuilder<List<ReviewModel>>(
          stream: reviewsCollection.snapshots().map((query) =>
              query.docs.map((item) => ReviewModel.fromJson(item)).toList()),
          builder: (context, reviewsSnapshot) {
            if (reviewsSnapshot.hasData) {
              reviewsSnapshot.data!.sort((a, b) => a.date.compareTo(b.date));

              return FB5Container(
                child: FB5Row(
                  children: [
                    FB5Col(
                      classNames: 'col-12',
                      child: SizedBox(
                        height: dPadding * (webScreen(context) ? 3 : 1),
                      ),
                    ),

                    FB5Col(
                      classNames: 'col-12',
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Flexible(
                            child: Text(
                              'Customers Reviews',
                              textAlign: TextAlign.center,
                              style: title(context: context, color: primary),
                            ),
                          ),
                          if (authSnapshot.hasData)
                            IconButton(
                              onPressed: () => showDialog(
                                context: Get.context!,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Create a new Review'),
                                  content: Form(
                                    key: formKey,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
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
                                    ElevatedButton(
                                      onPressed: () async {
                                        if (formKey.currentState!.validate()) {
                                          try {
                                            await usersCollection
                                                .doc()
                                                .get()
                                                .then(
                                                  (value) async => firestore
                                                      .collection('reviews')
                                                      .doc()
                                                      .set(ReviewModel(
                                                        name:
                                                            nameController.text,
                                                        review: reviewController
                                                            .text,
                                                        date: DateTime.now(),
                                                      ).toJson())
                                                      .then((value) =>
                                                          succesSnackBar(
                                                              'Added'))
                                                      .then((value) => page(
                                                          const CustomerHome())),
                                                );
                                          } on FirebaseException catch (error) {
                                            errorSnackBar(error.message!);
                                          }
                                        }
                                      },
                                      child: const Text('Submit'),
                                    ),
                                  ],
                                ),
                              ),
                              icon: const Icon(Icons.add, size: 18),
                            ),
                        ],
                      ),
                    ),

                    // Reviews
                    for (var review in reviewsSnapshot.data!)
                      FB5Col(
                        classNames: 'col-lg-4 col-md-6 col-sm-12 col-xs-12',
                        child: Padding(
                          padding: EdgeInsets.all(dPadding).copyWith(bottom: 0),
                          child: ListTile(
                            tileColor: secondary.withOpacity(0.5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.5),
                            ),

                            // Name
                            title: Text(
                              review.name,
                              style: TextStyle(fontSize: h4),
                            ),

                            // Review
                            subtitle: Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(review.review),
                            ),
                          ),
                        ),
                      ),

                    FB5Col(
                      classNames: 'col-12',
                      child: SizedBox(
                        height: dPadding * (webScreen(context) ? 3 : 1),
                      ),
                    ),
                  ],
                ),
              );
            } else if (reviewsSnapshot.hasError) {
              return Center(child: Text(reviewsSnapshot.error.toString()));
            } else if (reviewsSnapshot.connectionState ==
                ConnectionState.waiting) {
              return waitContainer();
            } else {
              return Container();
            }
          },
        ),
      );
}

class OurTeam extends StatelessWidget {
  const OurTeam({super.key});

  @override
  Widget build(BuildContext context) => StreamBuilder<List<TeamModel>>(
        stream: firestore.collection('teams').snapshots().map((query) =>
            query.docs.map((item) => TeamModel.fromJson(item)).toList()),
        builder: (context, teamsSnapshot) {
          if (teamsSnapshot.hasData) {
            return FB5Container(
              child: Column(
                children: [
                  SizedBox(
                    height: dPadding * (webScreen(context) ? 3 : 1),
                  ),

                  // Title & Add
                  Text(
                    'Our Team',
                    style: title(context: context, color: primary),
                  ),

                  // Team Members
                  FB5Row(
                    children: List.generate(
                      teamsSnapshot.data!.length,
                      (index) => FB5Col(
                        classNames: 'col-lg-4 col-md-6 col-sm-12 col-xs-12',
                        child: Card(
                          child: ListTile(
                            // Image
                            leading: AspectRatio(
                              aspectRatio: 1,
                              child: Container(
                                width: double.maxFinite,
                                height: double.maxFinite,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: MemoryImage(
                                      base64Decode(
                                          teamsSnapshot.data![index].image),
                                    ),
                                    fit: BoxFit.fill,
                                    colorFilter: overlay,
                                  ),
                                  borderRadius: BorderRadius.circular(12.5),
                                ),
                              ),
                            ),

                            // Name
                            title: Text(
                              teamsSnapshot.data![index].name,
                              style: TextStyle(fontSize: h4),
                            ),

                            // Job
                            subtitle: Text(teamsSnapshot.data![index].job),
                          ),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(
                    height: dPadding * (webScreen(context) ? 3 : 1),
                  ),
                ],
              ),
            );
          } else if (teamsSnapshot.hasError) {
            return Center(child: Text(teamsSnapshot.error.toString()));
          } else if (teamsSnapshot.connectionState == ConnectionState.waiting) {
            return waitContainer();
          } else {
            return Container();
          }
        },
      );
}

class ContactUs extends StatelessWidget {
  const ContactUs({super.key});

  @override
  Widget build(BuildContext context) => FB5Container(
        child: FB5Row(
          children: [
            FB5Col(
              classNames: 'col-12',
              child: SizedBox(
                height: dPadding * (webScreen(context) ? 3 : 1),
              ),
            ),

            // Contact Information
            FB5Col(
              classNames: 'col-lg-6 col-md-6 col-sm-12 col-xs-12 p-3',
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Contact Informations',
                    style: title(context: context, color: primary),
                  ),
                  link(
                    text: App.phone.international,
                    function: () async => await launchUrl(
                      Uri.parse('tel:${App.phone.international}'),
                    ),
                  ),
                  link(
                    text: App.email,
                    function: () async => await launchUrl(
                      Uri.parse(
                          'mailto:e.aeandas@gmail.com?subject=${App.name}&body= '),
                    ),
                  ),
                  link(
                    text: App.address['name'],
                    function: () async => await launchUrl(
                      Uri.parse(
                          'https://maps.google.com/?q=${App.address['latitude']},${App.address['longitude']}'),
                    ),
                  ),
                ],
              ),
            ),

            // Open Hours
            FB5Col(
              classNames: 'col-lg-6 col-md-6 col-sm-12 col-xs-12',
              child: Container(
                margin: webScreen(context)
                    ? EdgeInsets.zero
                    : EdgeInsets.all(dPadding),
                padding: EdgeInsets.all(dPadding),
                decoration:
                    BoxDecoration(color: secondary, boxShadow: [primaryShadow]),
                child: LayoutBuilder(
                  builder: (context, constraints) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Opening  Hours', style: title(context: context)),
                      Padding(
                        padding: EdgeInsets.all(dPadding),
                        child: Divider(color: primary, thickness: 1),
                      ),
                      Wrap(
                        children: [
                          SizedBox(
                            width: constraints.maxWidth / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Sat - Wed',
                                  style: TextStyle(fontSize: h4),
                                ),
                                Text(
                                  '8:00\n22:00',
                                  style: TextStyle(fontSize: h5),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: constraints.maxWidth / 2,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Thu - Fri',
                                  style: TextStyle(fontSize: h4),
                                ),
                                Text(
                                  '8:00\n22:00',
                                  style: TextStyle(fontSize: h5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Map
            FB5Col(
              classNames: 'col-12',
              child: Container(
                height: 300,
                margin: EdgeInsets.only(top: dPadding * 2),
                child: FlutterMap(
                  options: MapOptions(
                      initialCenter: LatLng(
                        App.address['latitude'],
                        App.address['longitude'],
                      ),
                      initialZoom: 15),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.arandas.yamifood_restaurant',
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: LatLng(App.address['latitude'],
                              App.address['longitude']),
                          child:
                              const Icon(Icons.location_pin, color: Colors.red),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),

            FB5Col(
              classNames: 'col-12',
              child: SizedBox(
                height: dPadding * (webScreen(context) ? 3 : 1),
              ),
            ),
          ],
        ),
      );

  Widget link({required String text, required void Function()? function}) {
    return TextButton(
      onPressed: function,
      style: ButtonStyle(
        foregroundColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.hovered) ||
                  states.contains(MaterialState.pressed) ||
                  states.contains(MaterialState.focused)
              ? primary
              : white,
        ),
      ),
      child: Text(text),
    );
  }
}
