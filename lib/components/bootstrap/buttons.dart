import '/exports.dart';

enum BootstrapButtonType { primary, success, info, warning, danger, link }

enum BootstrapButtonSize { large, small, mini }

class BootstrapButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final VoidCallback? onLongPress;
  final ValueChanged<bool>? onHover;
  final ValueChanged<bool>? onFocusChange;
  final FocusNode? focusNode;
  final bool autofocus;
  final Widget child;
  final BootstrapButtonType type;
  final BootstrapButtonSize size;
  bool get enabled => onPressed != null || onLongPress != null;

  const BootstrapButton({
    super.key,
    this.onPressed,
    this.onLongPress,
    required this.child,
    this.onHover,
    this.onFocusChange,
    this.focusNode,
    this.autofocus = false,
    this.type = BootstrapButtonType.primary,
    this.size = BootstrapButtonSize.large,
  });

  final Map<BootstrapButtonSize, double> _fontSize = const {
    BootstrapButtonSize.large: 18,
    BootstrapButtonSize.small: 12,
    BootstrapButtonSize.mini: 12,
  };

  final Map<BootstrapButtonSize, double> _borderRadius = const {
    BootstrapButtonSize.large: 6,
    BootstrapButtonSize.small: 3,
    BootstrapButtonSize.mini: 3,
  };

  final Map<BootstrapButtonSize, double> _paddingHorizontal = const {
    BootstrapButtonSize.large: 24,
    BootstrapButtonSize.small: 18,
    BootstrapButtonSize.mini: 12,
  };

  final Map<BootstrapButtonType, Color> _backgroundColor = const {
    BootstrapButtonType.primary: BootstrapColors.primary,
    BootstrapButtonType.success: BootstrapColors.success,
    BootstrapButtonType.info: BootstrapColors.info,
    BootstrapButtonType.warning: BootstrapColors.warning,
    BootstrapButtonType.danger: BootstrapColors.danger,
  };

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: onPressed == null ? 0.65 : 1,
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: _backgroundColor[type],
          padding: EdgeInsets.only(
            left: _paddingHorizontal[size]!,
            right: _paddingHorizontal[size]!,
            top: 8,
            bottom: 8,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(_borderRadius[size]!)),
        ),
        onPressed: onPressed,
        onLongPress: onLongPress,
        onHover: onHover,
        onFocusChange: onFocusChange,
        focusNode: focusNode,
        autofocus: autofocus,
        child: DefaultTextStyle.merge(
          style: TextStyle(
            fontSize: _fontSize[size],
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          child: child,
        ),
      ),
    );
  }
}
