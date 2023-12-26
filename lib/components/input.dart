import '/exports.dart';

class TextInputFeild extends StatelessWidget {
  final String text;
  final Color color;
  final Widget? suffixIcon;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final void Function(String)? onChanged;
  final Function(String)? onFieldSubmitted;

  const TextInputFeild({
    super.key,
    required this.text,
    required this.controller,
    required this.color,
    this.suffixIcon,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.obscureText = false,
    this.onChanged,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) => TextFormField(
        style: TextStyle(color: color),
        decoration: inputDecoration(text, color, suffixIcon),
        controller: controller,
        cursorColor: color,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: obscureText,
        validator: (value) {
          if (value!.isEmpty) {
            return '* required';
          }

          return null;
        },
        onChanged: onChanged,
        onFieldSubmitted: onFieldSubmitted,
      );
}

class PhoneInput extends StatelessWidget {
  final String text;
  final Color color;
  final PhoneController controller;
  final TextInputAction? textInputAction;

  const PhoneInput({
    super.key,
    required this.text,
    required this.color,
    required this.controller,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) => PhoneFormField(
        decoration: inputDecoration(text, color, null),
        defaultCountry: IsoCode.JO,
        controller: controller,
      );
}
