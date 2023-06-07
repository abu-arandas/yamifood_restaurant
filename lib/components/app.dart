import '/exports.dart';

class App {
  static String name = 'Yamifood Restaurant';
  static String description = lorem;
  static PhoneNumber phone = const PhoneNumber(isoCode: 'JO', nsn: '791568798');
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

  static void Function() facebook =
      () async => await launchUrl(Uri.parse('https://web.facebook.com/abu00arandas/'));
  static void Function() instagram =
      () async => await launchUrl(Uri.parse('https://www.instagram.com/abu_arandas/'));
}

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
double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
bool webScreen(BuildContext context) => screenWidth(context).isGreaterThan(767);

List<String> carousel = ['asset/slider-01.jpg', 'asset/slider-02.jpg', 'asset/slider-03.jpg'];
