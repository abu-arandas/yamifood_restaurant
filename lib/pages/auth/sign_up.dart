// ignore_for_file: depend_on_referenced_packages

import '/exports.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final formKey = GlobalKey<FormState>();
  XFile? pickedImage;
  ImageProvider? image;
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = PhoneController(null);
  final passwordController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    pickedImage == null
        ? image = NetworkImage(defaultImage)
        : image = FileImage(File(pickedImage!.path));

    return AuthWidget(
      body: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Image
            Container(
              width: webScreen(context) ? 200 : 150,
              height: webScreen(context) ? 200 : 150,
              margin: EdgeInsets.all(dPadding),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: image!,
                  fit: BoxFit.fill,
                  colorFilter: overlay,
                ),
                boxShadow: [primaryShadow],
              ),
              child: IconButton(
                onPressed: () async {
                  if (pickedImage == null) {
                    pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
                    setState(() {});
                  } else {
                    pickedImage = null;
                    setState(() {});
                  }
                },
                icon: Icon(
                  pickedImage == null ? FontAwesomeIcons.camera : FontAwesomeIcons.circleMinus,
                  color: white,
                  size: 18,
                ),
              ),
            ),
            SizedBox(height: dPadding),

            // Name
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextInputFeild(
                    text: 'First Name',
                    color: white,
                    controller: firstNameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                ),
                SizedBox(width: dPadding / 2),
                Expanded(
                  child: TextInputFeild(
                    text: 'Last Name',
                    color: white,
                    controller: lastNameController,
                    keyboardType: TextInputType.name,
                    textInputAction: TextInputAction.next,
                  ),
                ),
              ],
            ),
            SizedBox(height: dPadding),

            //  Email
            TextInputFeild(
              text: 'Email',
              color: white,
              controller: emailController,
              keyboardType: TextInputType.name,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height: dPadding),

            // Phone
            PhoneInput(text: 'Phone Number', color: white, controller: phoneController),
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
                  obscureText ? FontAwesomeIcons.eye : FontAwesomeIcons.lock,
                  color: white,
                  size: 16,
                ),
              ),
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (value) => validate(),
            ),
            SizedBox(height: dPadding),

            // Button
            BootstrapButton(
              onPressed: () => validate(),
              child: const Text('Sign Up'),
            ),
            SizedBox(height: dPadding),

            // Sign In
            RichText(
              text: TextSpan(
                text: 'Already have an account?\t\t',
                style: TextStyle(fontSize: 16, color: white),
                children: [
                  TextSpan(
                    text: 'Sign In',
                    recognizer: TapGestureRecognizer()..onTap = () => page(const SignIn()),
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
      ),
    );
  }

  validate() async {
    if (formKey.currentState!.validate()) {
      String imageData;

      if (pickedImage != null) {
        imageData = base64Encode(await pickedImage!.readAsBytes());
      } else {
        http.Response response = await http.get(Uri.parse(defaultImage));

        imageData = base64Encode(response.bodyBytes);
      }

      UserServices.instance.signUp(
        UserModel(
          name: {
            'firstName': firstNameController.text,
            'lastName': lastNameController.text,
          },
          email: emailController.text,
          image: imageData,
          phone: phoneController.value!,
          password: passwordController.text,
          role: 'Customer',
          token: '',
        ),
      );
    }
  }
}
