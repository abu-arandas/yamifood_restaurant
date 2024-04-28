import '/exports.dart';

class CustomerHome extends StatelessWidget {
  const CustomerHome({super.key});

  @override
  Widget build(BuildContext context) => CustomerScaf(
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
                padding: EdgeInsets.all(dPadding),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(carousel[index]),
                    fit: BoxFit.cover,
                    colorFilter: overlay,
                  ),
                ),
                child: FB5Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Welcome
                      RichText(
                        text: TextSpan(
                          text: 'Welcome to ',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall!
                              .copyWith(color: white),
                          children: <TextSpan>[
                            TextSpan(
                              text: App.name,
                              style: TextStyle(
                                color: primary,
                                fontWeight: FontWeight.bold,
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
                        child: Text(lorem, textAlign: TextAlign.center),
                      ),

                      // Shop More
                      ElevatedButton(
                        onPressed: () => page(const CustomerMenuPage()),
                        child: const Text('Shop More'),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // About Us
            CustomerAbout.aboutUs(context),

            // Our Menu
            Container(
              width: double.maxFinite,
              color: transparent.withOpacity(0.25),
              child: const CustomerMenu(),
            ),

            // Customers Reviews
            const CustomerReviews(),

            // Our Team
            Container(
              width: double.maxFinite,
              color: transparent.withOpacity(0.25),
              child: const OurTeam(),
            ),

            // Contact Us
            const ContactUs(),
          ],
        ),
      );
}
