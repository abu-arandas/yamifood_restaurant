import '/exports.dart';

class TextFormFeild extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final TextInputType textType;
  final TextInputAction textInputAction;

  const TextFormFeild({
    super.key,
    required this.text,
    required this.controller,
    required this.textType,
    this.textInputAction = TextInputAction.next,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (value!.isEmpty) {
            return '$text is empty';
          } else {
            return null;
          }
        },
        keyboardType: textType,
        textInputAction: textInputAction,
        cursorColor: black,
        decoration: InputDecoration(
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: primary, width: 2.0),
          ),
          focusColor: primary,
          hintText: text,
          border: const OutlineInputBorder(),
          labelText: text,
          labelStyle: TextStyle(color: white),
        ),
      ),
    );
  }
}
