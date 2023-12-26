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

  static Widget aboutUs(context) => Container(
        padding: EdgeInsets.all(webScreen(context) ? dPadding * 3 : dPadding),
        constraints: BoxConstraints(maxWidth: maxWidth(context)),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Info
            Div(
              lg: Col.col6,
              md: Col.col6,
              sm: Col.col12,
              child: Column(
                crossAxisAlignment: webScreen(context) ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                children: [
                  Text(
                    'Who we are',
                    style: title(context: context, color: primary),
                  ),
                  Padding(padding: const EdgeInsets.all(8), child: Text(App.description)),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: App.about.length,
                    itemBuilder: (context, index) => ListTile(
                      leading: const Icon(Icons.circle),
                      title: Text(App.about[index]),
                    ),
                  ),
                ],
              ),
            ),

            // Image
            Div(lg: Col.col6, md: Col.col6, sm: Col.col12, child: Image.asset('asset/about.png')),
          ],
        ),
      );
}
