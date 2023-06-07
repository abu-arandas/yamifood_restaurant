import '/exports.dart';

class CustomerAbout extends StatelessWidget {
  const CustomerAbout({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomerScaf(
      pageName: 'About Us',
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // About Us
          aboutUs(context),

          // Our Team
          Container(color: transparent.withOpacity(0.25), child: const OurTeam()),

          // Customer Reviews
          const CustomerReviews(),
        ],
      ),
    );
  }

  static Widget aboutUs(context) {
    return BootstrapContainer(
      padding: EdgeInsets.all(webScreen(context) ? dPadding * 3 : dPadding),
      children: [
        // Info
        BootstrapCol(
          sizes: 'col-lg-6 col-md-6 col-sm-12',
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BootstrapHeading.h2(text: 'Who We are', color: primary),
              BootstrapParagraph(text: lorem),
              ListView(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                children: const [
                  ListTile(
                    leading: Text("\u2022", style: TextStyle(fontSize: 30)),
                    title: Text('Delicious butternut squash hunk.'),
                  ),
                  ListTile(
                    leading: Text("\u2022", style: TextStyle(fontSize: 30)),
                    title: Text('Flavor centerpiece plate, delicious ribs bone-in meat.'),
                  ),
                  ListTile(
                    leading: Text("\u2022", style: TextStyle(fontSize: 30)),
                    title: Text('Romantic fall-off-the-bone butternut chuck rice burgers.'),
                  ),
                  ListTile(
                    leading: Text("\u2022", style: TextStyle(fontSize: 30)),
                    title: Text('Romantic fall-off-the-bone butternut chuck rice burgers.'),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Image
        BootstrapCol(sizes: 'col-lg-6 col-md-6 col-sm-12', child: Image.asset('asset/about.png')),
      ],
    );
  }
}
