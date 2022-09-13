import '/exports.dart';

class SocialButton extends StatelessWidget {
  final IconData icon;
  final Color iconcolor, bgcolor;
  final void Function() onPressed;

  const SocialButton({
    super.key,
    required this.icon,
    this.iconcolor = Colors.white,
    this.bgcolor = Colors.transparent,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 10),
      child: TextButton(
          onPressed: onPressed,
          style: ButtonStyle(
            shape: MaterialStateProperty.all(const CircleBorder()),
            padding: MaterialStateProperty.all(const EdgeInsets.all(20)),
            backgroundColor: MaterialStateProperty.all(bgcolor),
            overlayColor: MaterialStateProperty.resolveWith<Color?>((states) {
              if (states.contains(MaterialState.pressed)) {
                return primary.withOpacity(0.5);
              }
              return null;
            }),
          ),
          child: Icon(
            icon,
            color: iconcolor,
          )),
    );
  }
}
