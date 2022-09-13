import '/exports.dart';

class MyScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? appBarActions;

  const MyScaffold(
      {super.key, required this.title, required this.body, this.appBarActions});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: transparent,
        title: Text(title),
        actions: appBarActions,
      ),
      body: SingleChildScrollView(
        primary: false,
        physics: const NeverScrollableScrollPhysics(),
        reverse: false,
        child: Container(
          width: size.width,
          height: size.height * 0.91,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: const AssetImage('asset/bg.jpg'),
              colorFilter: ColorFilter.mode(overlay, BlendMode.dstATop),
              fit: BoxFit.fill,
            ),
          ),
          child: body,
        ),
      ),
    );
  }
}
