import '/exports.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseMessaging messaging = FirebaseMessaging.instance;

final usersCollection = firestore.collection('users');
final categoriesCollection = firestore.collection('categories');
final productsCollection = firestore.collection('products');
final ordersCollection = firestore.collection('orders');
final reviewsCollection = firestore.collection('reviews');

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
      border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.5), borderSide: BorderSide(color: color)),
      focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.5), borderSide: BorderSide(color: color)),
      enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.5), borderSide: BorderSide(color: color)),
      errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.5), borderSide: BorderSide(color: danger)),
    );

CircularProgressIndicator waitContainer() => CircularProgressIndicator(color: primary);

errorSnackBar(String text) => ScaffoldMessenger.of(Get.context!)
  ..hideCurrentSnackBar()
  ..showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: transparent,
      content: AwesomeSnackbarContent(
        title: 'On Snap!',
        message: text,
        contentType: ContentType.failure,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ),
  );

succesSnackBar(String text) => ScaffoldMessenger.of(Get.context!)
  ..hideCurrentSnackBar()
  ..showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.fixed,
      backgroundColor: Colors.transparent,
      content: AwesomeSnackbarContent(
        title: 'Success',
        message: text,
        contentType: ContentType.success,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
