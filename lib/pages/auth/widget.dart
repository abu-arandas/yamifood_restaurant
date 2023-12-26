import '/exports.dart';

class AuthWidget extends StatelessWidget {
  final Widget body;
  const AuthWidget({super.key, required this.body});

  @override
  Widget build(BuildContext context) => CustomerScaf(
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
            child: Wrap(
              children: [
                Text(
                  'Welcome to ${App.name}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: h3,
                    color: white.withOpacity(0.75),
                  ),
                ),
                Text(
                  'Complete your information to get in',
                  style: TextStyle(
                    fontSize: h5,
                    color: white.withOpacity(0.75),
                  ),
                ),
                Padding(padding: EdgeInsets.all(dPadding), child: body)
              ],
            ),
          ),
        ),
      );
}
