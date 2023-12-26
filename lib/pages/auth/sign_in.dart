import '/exports.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) => AuthWidget(
          body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //  Email
            TextInputFeild(
              text: 'Email',
              color: white,
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: dPadding),

            // Password
            TextInputFeild(
              text: 'Password',
              color: white,
              controller: passwordController,
              keyboardType: TextInputType.visiblePassword,
              obscureText: obscureText,
              suffixIcon: IconButton(
                onPressed: () => setState(() => obscureText = !obscureText),
                icon: Icon(
                  obscureText ? Icons.remove_red_eye : Icons.lock,
                  color: white,
                  size: 16,
                ),
              ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) => validate(),
            ),
            SizedBox(height: dPadding),

            // Button
            ElevatedButton(
              onPressed: () => validate(),
              child: const Text('Sign In'),
            ),
            SizedBox(height: dPadding),

            // Sign Up
            RichText(
              text: TextSpan(
                text: 'Don\'t have an account?\t\t',
                style: TextStyle(fontSize: 16, color: white),
                children: [
                  TextSpan(
                    text: 'Sign Up',
                    recognizer: TapGestureRecognizer()..onTap = () => page(const SignUp()),
                    style: TextStyle(
                      fontSize: 17,
                      decoration: TextDecoration.underline,
                      color: white,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ));

  validate() async {
    if (formKey.currentState!.validate()) {
      UserServices.instance.signIn(emailController.text, passwordController.text);
    }
  }
}
