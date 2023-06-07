import '/exports.dart';

class CustomerHome extends StatelessWidget {
  const CustomerHome({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomerScaf(
      pageName: 'Home',
      body: Column(
        children: [
          // Carousel
          CarouselSlider.builder(
            options: CarouselOptions(
              autoPlay: true,
              autoPlayCurve: Curves.easeIn,
              autoPlayAnimationDuration: const Duration(seconds: 1),
              autoPlayInterval: const Duration(seconds: 5),
              height: screenHeight(context),
              viewportFraction: 1,
            ),
            itemCount: carousel.length,
            itemBuilder: (context, index, realIndex) => Container(
              width: double.maxFinite,
              height: double.maxFinite,
              padding: EdgeInsets.symmetric(vertical: dPadding, horizontal: dPadding * 2),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(carousel[index]),
                  fit: BoxFit.fill,
                  colorFilter: overlay,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(),
                  // Welcome
                  RichText(
                    text: TextSpan(
                      text: 'Welcome to ',
                      style: TextStyle(
                        fontSize: 18,
                        color: white,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          text: App.name,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: primary,
                          ),
                        )
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: dPadding),

                  // Text
                  Container(
                    constraints: const BoxConstraints(maxWidth: 450),
                    padding: EdgeInsets.symmetric(vertical: dPadding / 2),
                    child: BootstrapParagraph(text: lorem, center: true),
                  ),

                  // Shop More
                  BootstrapButton(
                      onPressed: () => page(const CustomerMenuPage()),
                      child: const Text('Shop More')),
                  const Spacer(),

                  // Social
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        color: white,
                        width: 100,
                        height: 1,
                        margin: EdgeInsets.all(dPadding),
                      ),
                      IconButton(
                        onPressed: App.facebook,
                        icon: Icon(
                          FontAwesomeIcons.facebook,
                          size: 18,
                          color: white,
                        ),
                      ),
                      IconButton(
                        onPressed: App.instagram,
                        icon: Icon(
                          FontAwesomeIcons.instagram,
                          size: 18,
                          color: white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // About Us
          CustomerAbout.aboutUs(context),

          // Our Menu
          Container(color: transparent.withOpacity(0.25), child: const CustomerMenu()),

          // Customers Reviews
          const CustomerReviews(),

          // Our Team
          Container(color: transparent.withOpacity(0.25), child: const OurTeam()),

          // Contact Us
          const ContactUs(),
        ],
      ),
    );
  }
}
