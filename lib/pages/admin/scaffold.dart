import '/exports.dart';

class AdminScaf extends StatefulWidget {
  final Widget body;
  const AdminScaf({super.key, required this.body});

  @override
  State<AdminScaf> createState() => _AdminScafState();
}

class _AdminScafState extends State<AdminScaf> {
  final ScrollController scrollController = ScrollController();
  bool scrolled = false;

  @override
  void initState() {
    super.initState();

    // Show Top Button
    scrollController.addListener(
      () => setState(() => scrolled = scrollController.offset >= screenHeight(context) * 0.25 ? true : false),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: scrolled ? 75 : 100,
          backgroundColor: secondary,
          title: App.logoWidget(context),
          actions: [
            IconButton(
              onPressed: () => page(const Home()),
              icon: const Icon(Icons.home),
            ),
            IconButton(
              onPressed: () => page(const AdminMenu()),
              icon: const Icon(Icons.shopping_bag),
            ),
            IconButton(
              onPressed: () => page(const AdminOrdersPage()),
              icon: const Icon(Icons.history),
            ),
            IconButton(
              onPressed: () => UserServices.instance.signOut(),
              icon: const Icon(Icons.logout),
            ),
          ],
        ),
        body: SingleChildScrollView(
          controller: scrollController,
          child: Padding(padding: EdgeInsets.symmetric(vertical: dPadding), child: widget.body),
        ),
      );
}
