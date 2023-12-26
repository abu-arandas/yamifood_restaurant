import '/exports.dart';

class App {
  static String name = 'Yamifood Restaurant';
  static String description = lorem;
  static List<String> about = [
    'Delicious butternut squash hunk.',
    'Flavor centerpiece plate, delicious ribs bone-in meat.',
    'Romantic fall-off-the-bone butternut chuck rice burgers.',
    'Romantic fall-off-the-bone butternut chuck rice burgers.'
  ];
  static PhoneNumber phone = const PhoneNumber(isoCode: IsoCode.JO, nsn: '791568798');
  static String email = 'e00arandas@gmail.com';
  static Map address = {
    'name': 'Abdallah Ben Farroukh St. 3, Amman',
    'latitude': 31.985959,
    'longitude': 35.925523,
  };

  static String logoString =
      'https://firebasestorage.googleapis.com/v0/b/yamifood-restaurants-app.appspot.com/o/logo.png?alt=media&token=d2b07083-919e-45d8-b617-ad6eefd2d6d3&_gl=1*31ti3b*_ga*MzMyNzgwNTIzLjE2ODUyMjEwMjE.*_ga_CW55HF8NVT*MTY4NTUzMzczMS4xMC4xLjE2ODU1MzM3MzUuMC4wLjA';

  static Widget logoWidget(context) => Container(
        alignment: Alignment.centerLeft,
        margin: EdgeInsets.all(dPadding / 2).copyWith(bottom: dPadding),
        child: InkWell(
          onTap: () => page(const Home()),
          child: Image.asset('asset/logo.png', fit: BoxFit.fill),
        ),
      );

  static void Function() facebook = () async => await launchUrl(Uri.parse('https://web.facebook.com/abu00arandas/'));
  static void Function() instagram = () async => await launchUrl(Uri.parse('https://www.instagram.com/abu_arandas/'));
}

double h1 = 36;
double h2 = 30;
double h3 = 24;
double h4 = 18;
double h5 = 14;
double h6 = 12;

Color primary = const Color(0xFFCFA671);
Color secondary = const Color(0xFF101010);
Color white = const Color(0xFFF4F5F9);
Color grey = const Color(0xFF868889);
Color success = const Color(0xFF01b075);
Color danger = const Color(0xFFe66430);
Color transparent = Colors.transparent;

ColorFilter overlay = ColorFilter.mode(secondary.withOpacity(0.5), BlendMode.darken);

BoxShadow primaryShadow = BoxShadow(color: primary, blurRadius: 2, blurStyle: BlurStyle.outer);
BoxShadow whiteShadow = BoxShadow(color: white, blurRadius: 10, blurStyle: BlurStyle.outer);
BoxShadow blackShadow = BoxShadow(color: secondary, blurRadius: 10, blurStyle: BlurStyle.outer);

double dPadding = 16.0;
double screenWidth(BuildContext context) => MediaQuery.sizeOf(context).width;
double screenHeight(BuildContext context) => MediaQuery.sizeOf(context).height;
bool webScreen(BuildContext context) => screenWidth(context).isGreaterThan(767);

List<String> carousel = ['asset/slider-01.jpg', 'asset/slider-02.jpg', 'asset/slider-03.jpg'];

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseMessaging messaging = FirebaseMessaging.instance;

CollectionReference<Map<String, dynamic>> usersCollection = firestore.collection('users');
CollectionReference<Map<String, dynamic>> categoriesCollection = firestore.collection('categories');
CollectionReference<Map<String, dynamic>> productsCollection = firestore.collection('products');
CollectionReference<Map<String, dynamic>> ordersCollection = firestore.collection('orders');
CollectionReference<Map<String, dynamic>> reviewsCollection = firestore.collection('reviews');

String lorem =
    'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque auctor suscipit feugiat. Ut at pellentesque ante, sed convallis arcu. Nullam facilisis, eros in eleifend luctus, odio ante sodales augue, eget lacinia lectus erat et sem.';

String defaultImage =
    'https://firebasestorage.googleapis.com/v0/b/yamifood-restaurants-app.appspot.com/o/default-user.jpg?alt=media&token=b5605f58-d076-4b94-b754-9e4201dc4e5b';

InputDecoration inputDecoration(String text, Color color, Widget? suffixIcon) => InputDecoration(
      label: Text(text),
      hintText: text,
      labelStyle: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
      hintStyle: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16),
      suffixIcon: suffixIcon,
      focusColor: color,
      hoverColor: color,
      contentPadding: EdgeInsets.all(dPadding),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.5), borderSide: BorderSide(color: color)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.5), borderSide: BorderSide(color: color)),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.5), borderSide: BorderSide(color: color)),
      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12.5), borderSide: BorderSide(color: danger)),
    );

Center waitContainer() => Center(child: CircularProgressIndicator(color: primary));

errorSnackBar(String text) => ScaffoldMessenger.of(Get.context!)
  ..hideCurrentSnackBar()
  ..showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: danger,
      content: ListTile(title: const Text('On Snap!'), subtitle: Text(text)),
    ),
  );

succesSnackBar(String text) => ScaffoldMessenger.of(Get.context!)
  ..hideCurrentSnackBar()
  ..showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: success,
      content: ListTile(title: const Text('Success'), subtitle: Text(text)),
    ),
  );

page(page) => Navigator.of(Get.context!).push(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) => SlideTransition(
        position: Tween(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeInOut,
        )),
        child: child,
      ),
    ));

TextStyle title({required BuildContext context, Color? color}) => Theme.of(context).textTheme.displayMedium!.copyWith(
      fontWeight: FontWeight.bold,
      color: color,
    );

double maxWidth(BuildContext context) {
  double width = MediaQuery.sizeOf(context).width;

  if (width.isGreaterThan(1200)) {
    return 1140;
  } else if (width.isGreaterThan(997) && width.isLowerThan(1200)) {
    return 960;
  } else if (width.isGreaterThan(767) && width.isLowerThan(997)) {
    return 720;
  } else {
    return width;
  }
}
