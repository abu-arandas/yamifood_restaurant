import '/exports.dart';

class DriverScaf extends StatefulWidget {
  final String pageName;
  final Widget body;
  const DriverScaf({super.key, required this.pageName, required this.body});

  @override
  State<DriverScaf> createState() => _DriverScafState();
}

class _DriverScafState extends State<DriverScaf> {
  final ScrollController scrollController = ScrollController();
  bool scrolled = false;

  @override
  void initState() {
    super.initState();

    // Show Top Button
    scrollController.addListener(
      () => setState(
          () => scrolled = scrollController.offset >= screenHeight(context) * 0.25 ? true : false),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AddressServices.instance.driverAddress();

    return Scaffold(
      // App Bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: scrolled ? 75 : 100,
        backgroundColor: scrolled ? secondary : transparent.withOpacity(0.25),
        title: App.logoWidget(context),
        actions: [
          IconButton(
            onPressed: () => page(const Home()),
            icon: Icon(
              FontAwesomeIcons.house,
              size: 18,
              color: widget.pageName == 'Home' ? primary : white,
            ),
          ),
          IconButton(
            onPressed: () => page(const DriverOrdersPage()),
            icon: Icon(
              FontAwesomeIcons.clockRotateLeft,
              size: 18,
              color: widget.pageName == 'History' ? primary : white,
            ),
          ),
          IconButton(
            onPressed: () => UserServices.instance.signOut(),
            icon: Icon(
              FontAwesomeIcons.arrowRightFromBracket,
              size: 18,
              color: white,
            ),
          ),
        ],
      ),

      // Body
      body: SingleChildScrollView(controller: scrollController, child: widget.body),

      // Back to Top
      floatingActionButton: scrolled
          ? FloatingActionButton(
              onPressed: () => scrollController.animateTo(
                0,
                duration: const Duration(seconds: 1),
                curve: Curves.easeInOut,
              ),
              child: const Icon(
                FontAwesomeIcons.arrowUp,
                size: 18,
              ),
            )
          : Container(),
    );
  }
}
