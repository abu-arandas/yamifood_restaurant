import '/exports.dart';

class CustomerAbout extends StatelessWidget {
  const CustomerAbout({super.key});

  @override
  Widget build(BuildContext context) => CustomerScaf(
        pageName: 'About Us',
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // About Us
            aboutUs(context),

            // Our Team
            Container(
              width: double.maxFinite,
              alignment: Alignment.center,
              color: transparent.withOpacity(0.25),
              child: const OurTeam(),
            ),

            // Customer Reviews
            const CustomerReviews(),
          ],
        ),
      );

  static Widget aboutUs(context) => FB5Container(
        child: FB5Row(
          classNames: 'align-items-center',
          children: [
            // Info
            FB5Col(
              classNames: 'col-lg-6 col-md-6 col-sm-12 col-xs-12',
              child: Column(
                crossAxisAlignment: webScreen(context)
                    ? CrossAxisAlignment.start
                    : CrossAxisAlignment.center,
                children: [
                  Text(
                    'Who we are',
                    style: title(context: context, color: primary),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(App.description),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: App.about.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: const Icon(Icons.circle, size: 12),
                      title: Text(App.about[index]),
                    ),
                  ),
                ],
              ),
            ),

            // Image

            FB5Col(
              classNames: 'col-lg-6 col-md-6 col-sm-12 col-xs-12',
              child: Image.asset('asset/about.png'),
            ),
          ],
        ),
      );
}
