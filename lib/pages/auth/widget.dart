import '/exports.dart';

class AuthWidget extends StatelessWidget {
  final Widget body;
  const AuthWidget({super.key, required this.body});

  @override
  Widget build(BuildContext context) {
    return CustomerScaf(
      pageName: 'Sign In',
      body: Container(
        width: screenWidth(context),
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          margin: EdgeInsets.symmetric(vertical: dPadding * 2, horizontal: dPadding),
          padding: EdgeInsets.all(dPadding),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: secondary.withOpacity(0.25),
            borderRadius: BorderRadius.circular(12.5),
          ),
          child: BootstrapContainer(
            children: [
              BootstrapHeading.h3(
                text: 'Welcome to ${App.name}',
                color: white.withOpacity(0.75),
                center: true,
              ),
              BootstrapHeading.h5(
                text: 'Complete your information to get in',
                color: white.withOpacity(0.75),
              ),
              Padding(padding: EdgeInsets.all(dPadding), child: body)
            ],
          ),
        ),
      ),
    );
  }
}
