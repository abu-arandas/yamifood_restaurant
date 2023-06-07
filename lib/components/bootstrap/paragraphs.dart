// ignore_for_file: must_be_immutable
import '/exports.dart';

// P
class BootstrapParagraph extends StatelessWidget {
  final String text;
  final bool lead;
  final bool center;

  const BootstrapParagraph({
    super.key,
    required this.text,
    this.lead = false,
    this.center = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: lead ? 16 : 8),
      child: Flexible(
        child: Text(
          text,
          style: lead
              ? DefaultTextStyle.of(context)
                  .style
                  .merge(const TextStyle(fontSize: 21, fontWeight: FontWeight.w300))
              : DefaultTextStyle.of(context).style,
          textAlign: center ? TextAlign.center : TextAlign.left,
        ),
      ),
    );
  }
}

// H1, H2, H3 ,H4, H5 ,H6
class BootstrapHeading extends StatelessWidget {
  static const FontWeight _fontWeight = FontWeight.w500;
  final String text;
  final double _fontSize;
  final double marginTop;
  final Color color;
  final bool center;

  const BootstrapHeading.h1({
    super.key,
    required this.text,
    this.marginTop = 16,
    this.color = Colors.white,
    this.center = false,
  }) : _fontSize = 36;

  const BootstrapHeading.h2({
    super.key,
    required this.text,
    this.marginTop = 16,
    this.color = Colors.white,
    this.center = false,
  }) : _fontSize = 30;

  const BootstrapHeading.h3({
    super.key,
    required this.text,
    this.marginTop = 16,
    this.color = Colors.white,
    this.center = false,
  }) : _fontSize = 24;

  const BootstrapHeading.h4({
    super.key,
    required this.text,
    this.marginTop = 8,
    this.color = Colors.white,
    this.center = false,
  }) : _fontSize = 18;

  const BootstrapHeading.h5({
    super.key,
    required this.text,
    this.marginTop = 8,
    this.color = Colors.white,
    this.center = false,
  }) : _fontSize = 14;

  const BootstrapHeading.h6({
    super.key,
    required this.text,
    this.marginTop = 8,
    this.color = Colors.white,
    this.center = false,
  }) : _fontSize = 12;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: marginTop),
      child: Flexible(
        child: Text(
          text,
          style: DefaultTextStyle.of(context).style.merge(
                TextStyle(fontSize: _fontSize, fontWeight: _fontWeight, color: color),
              ),
          textAlign: center ? TextAlign.center : TextAlign.left,
        ),
      ),
    );
  }
}
