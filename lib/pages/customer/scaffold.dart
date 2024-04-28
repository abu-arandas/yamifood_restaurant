import '/exports.dart';

class CustomerScaf extends StatefulWidget {
  final String pageName;
  final Widget body;
  const CustomerScaf({super.key, required this.pageName, required this.body});

  @override
  State<CustomerScaf> createState() => _CustomerScaffoldState();
}

class _CustomerScaffoldState extends State<CustomerScaf> {
  final ScrollController scrollController = ScrollController();
  bool scrolled = false;

  @override
  void initState() {
    super.initState();

    // Show Top Button
    scrollController.addListener(
      () => setState(() =>
          scrolled = scrollController.offset >= screenHeight(context) * 0.25),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<User?>(
        stream: auth.authStateChanges(),
        builder: (context, authSnapshot) {
          List navBarItems() => [
                link(
                  text: 'Home',
                  function: () => page(const CustomerHome()),
                ),
                link(
                  text: 'About Us',
                  function: () => page(const CustomerAbout()),
                ),
                link(
                  text: 'Our Menu',
                  function: () => page(const CustomerMenuPage()),
                ),
                if (authSnapshot.hasData)
                  link(
                    text: 'Profile',
                    function: () => page(const UserProfile()),
                  ),
                if (authSnapshot.hasData)
                  link(
                    text: 'Orders',
                    function: () => page(const OrdersPage()),
                  ),
                if (!authSnapshot.hasData)
                  link(
                    text: 'Sign In',
                    function: () => page(const SignIn()),
                  ),
                link(
                  text: 'Contact Us',
                  function: () => page(
                    const CustomerScaf(
                        pageName: 'Contact Us', body: ContactUs()),
                  ),
                ),
                if (authSnapshot.hasData)
                  link(
                    text: 'sign Out',
                    function: () => UserServices.instance.signOut(),
                  ),
              ];

          return Scaffold(
            extendBodyBehindAppBar: widget.pageName == 'Home',

            // App Bar
            appBar: PreferredSize(
              preferredSize: Size(double.maxFinite, scrolled ? 75 : 100),
              child: Container(
                width: double.maxFinite,
                color: scrolled ? secondary : transparent.withOpacity(0.25),
                child: FB5Container(
                  child: Row(
                    children: [
                      App.logoWidget(context),
                      const Spacer(),

                      // Large Screen Links
                      if (webScreen(context))
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: List.generate(
                            navBarItems().length,
                            (index) => navBarItems()[index],
                          ),
                        ),

                      // Cart
                      IconButton(
                        onPressed: () => page(const Cart()),
                        icon: const Icon(Icons.shopping_cart),
                      ),

                      // Small Screen Menu
                      if (!webScreen(context))
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: dPadding),
                          child: PopupMenuButton(
                            itemBuilder: (BuildContext context) =>
                                List.generate(
                              navBarItems().length,
                              (index) =>
                                  PopupMenuItem(child: navBarItems()[index]),
                            ),
                            child: const Icon(Icons.menu),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Body
            body: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Page Name
                  if (widget.pageName != 'Home')
                    Container(
                      width: screenWidth(context),
                      height: screenHeight(context) / 3,
                      padding: EdgeInsets.all(dPadding),
                      color: transparent.withOpacity(0.25),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.pageName.toUpperCase(),
                            style: title(context: context, color: primary),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () => page(const CustomerHome()),
                                child: Text(
                                  'Home',
                                  style: TextStyle(
                                    color: white,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: dPadding),
                                child: Text(
                                  '\\',
                                  style: TextStyle(color: white),
                                ),
                              ),
                              Text(
                                widget.pageName,
                                style: TextStyle(
                                  color: primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                  // Body
                  widget.body,

                  // Footer
                  Container(
                    width: double.maxFinite,
                    decoration: BoxDecoration(boxShadow: [blackShadow]),
                    child: Column(
                      children: [
                        // Main Footer
                        FB5Container(
                          child: FB5Row(
                            classNames: 'jusify-content-center',
                            children: [
                              // About
                              FB5Col(
                                classNames:
                                    'col-lg-4 col-md-6 col-sm-12 col-xs-12 p-3',
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    App.logoWidget(context),
                                    Padding(
                                      padding: EdgeInsets.all(dPadding),
                                      child: Text(App.description),
                                    ),
                                  ],
                                ),
                              ),

                              // Links
                              FB5Col(
                                classNames:
                                    'col-lg-4 col-md-6 col-sm-12 col-xs-12 p-3',
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Links',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: primary,
                                          ),
                                    ),
                                    for (var item in navBarItems()) item,
                                  ],
                                ),
                              ),

                              // Informations
                              FB5Col(
                                classNames:
                                    'col-lg-4 col-md-6 col-sm-12 col-xs-12 p-3',
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Dont Be Shy, Say HI!',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headlineMedium!
                                          .copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: primary,
                                          ),
                                    ),
                                    link(
                                      text: App.phone.international,
                                      function: () async => await launchUrl(
                                        Uri.parse(
                                            'tel:${App.phone.international}'),
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
                            ],
                          ),
                        ),

                        // Ehab Arandas
                        Container(
                          width: screenWidth(Get.context!),
                          padding: EdgeInsets.all(dPadding / 2),
                          color: transparent.withOpacity(0.25),
                          child: Wrap(
                            alignment: WrapAlignment.center,
                            runAlignment: WrapAlignment.center,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              const Text(
                                'All Rights Reserved. © 2023',
                                style: TextStyle(fontSize: 15),
                              ),
                              TextButton(
                                onPressed: () => page(const CustomerHome()),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: dPadding / 2),
                                ),
                                child: Text(App.name),
                              ),
                              const Text(
                                'Designed by',
                                style: TextStyle(fontSize: 15),
                              ),
                              TextButton(
                                onPressed: () async => await launchUrl(
                                  Uri.parse('https://ehab-arandas.web.app/'),
                                ),
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 0, horizontal: dPadding / 2),
                                ),
                                child: const Text('Ehab Arandas'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Back to Top
            floatingActionButton: scrolled
                ? FloatingActionButton(
                    onPressed: () => scrollController.animateTo(
                      0,
                      duration: const Duration(seconds: 1),
                      curve: Curves.easeInOut,
                    ),
                    child: const Icon(Icons.keyboard_arrow_up),
                  )
                : null,
          );
        },
      );

  Widget link({required String text, required void Function()? function}) =>
      TextButton(
        onPressed: function,
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.resolveWith((states) =>
              states.contains(MaterialState.hovered) ||
                      states.contains(MaterialState.pressed) ||
                      states.contains(MaterialState.focused) ||
                      widget.pageName == text
                  ? primary
                  : white),
          textStyle: MaterialStateProperty.resolveWith((states) => states
                      .contains(MaterialState.hovered) ||
                  states.contains(MaterialState.pressed) ||
                  states.contains(MaterialState.focused) ||
                  widget.pageName == text
              ? const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
              : const TextStyle(fontSize: 16, fontWeight: FontWeight.normal)),
        ),
        child: Text(text),
      );
}
