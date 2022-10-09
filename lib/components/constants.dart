import '/exports.dart';

Image logo = Image.asset('asset/logo.png');

Color primary = const Color(0xFFCFA671);
Color overlay = Colors.black38;
Color transparent = Colors.transparent;
Color black = Colors.black;
Color white = Colors.white;
Color grey = Colors.grey;

double dPadding = 16.0;

// Widgets
Widget endOfPage(context) {
  return Padding(
    padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
  );
}

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> snackBar(
    context, String text) {
  final snackBar = SnackBar(
    content: Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 16),
      textAlign: TextAlign.center,
    ),
    backgroundColor: (Colors.transparent.withOpacity(0.5)),
    padding: EdgeInsets.all(dPadding),
  );
  return ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Widget waitPage() {
  return Scaffold(
    body: Container(
      width: double.maxFinite,
      height: double.maxFinite,
      padding: EdgeInsets.all(dPadding),
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/images/favicon.png'),
          CircularProgressIndicator(
            color: primary,
          ),
        ],
      ),
    ),
  );
}

Widget waitContainer() {
  return Center(
      child: SizedBox(
          width: 100,
          height: 100,
          child: CircularProgressIndicator(color: primary)));
}
