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
    return AdminScaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: scrolled ? 75 : 100,
        backgroundColor: secondary,
        title: App.logoWidget(context),
        actions: [
          IconButton(
            onPressed: () => UserServices.instance.signOut(),
            icon: const Icon(
              FontAwesomeIcons.arrowRightFromBracket,
              size: 18,
            ),
          ),
        ],
      ),
      sideBar: SideBar(
        backgroundColor: secondary,
        selectedRoute: '/',
        onSelected: (item) => item.route != null ? page(item.page) : {},
        textStyle: TextStyle(color: white),
        activeTextStyle: TextStyle(color: primary),
        borderColor: transparent,
        items: const [
          AdminMenuItem(title: 'Home', route: '/Home', page: AdminHome()),
          AdminMenuItem(
            title: 'Menu',
            children: [
              AdminMenuItem(title: 'Categories', route: '/Categories', page: AdminCategories()),
              AdminMenuItem(title: 'Products', route: '/Products', page: AdminProducts()),
            ],
          ),
          AdminMenuItem(title: 'Orders', route: '/Orders', page: AdminOrdersPage()),
        ],
      ),
      body: SingleChildScrollView(
        controller: scrollController,
        child: Padding(padding: EdgeInsets.symmetric(vertical: dPadding), child: widget.body),
      ),
    );
  }
}
