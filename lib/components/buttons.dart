import '/exports.dart';

class PrimaryButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  const PrimaryButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.5)),
        ),
        padding: MaterialStatePropertyAll(EdgeInsets.all(dPadding)),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.hovered) ||
                  states.contains(MaterialState.dragged) ||
                  states.contains(MaterialState.pressed)
              ? white
              : primary,
        ),
        foregroundColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.hovered) ||
                  states.contains(MaterialState.dragged) ||
                  states.contains(MaterialState.pressed)
              ? primary
              : white,
        ),
      ),
      child: Text(text),
    );
  }
}

class SuccessButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  const SuccessButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.5)),
        ),
        padding: MaterialStatePropertyAll(EdgeInsets.all(dPadding)),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.hovered) ||
                  states.contains(MaterialState.dragged) ||
                  states.contains(MaterialState.pressed)
              ? white
              : success,
        ),
        foregroundColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.hovered) ||
                  states.contains(MaterialState.dragged) ||
                  states.contains(MaterialState.pressed)
              ? success
              : white,
        ),
      ),
      child: Text(text),
    );
  }
}

class DangerButton extends StatelessWidget {
  final void Function()? onPressed;
  final String text;
  const DangerButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        shape: MaterialStatePropertyAll(
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.5)),
        ),
        padding: MaterialStatePropertyAll(EdgeInsets.all(dPadding)),
        backgroundColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.hovered) ||
                  states.contains(MaterialState.dragged) ||
                  states.contains(MaterialState.pressed)
              ? white
              : danger,
        ),
        foregroundColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.hovered) ||
                  states.contains(MaterialState.dragged) ||
                  states.contains(MaterialState.pressed)
              ? danger
              : white,
        ),
      ),
      child: Text(text),
    );
  }
}
