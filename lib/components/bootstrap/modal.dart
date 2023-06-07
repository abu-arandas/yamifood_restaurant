import '/exports.dart';

class BootstrapModal extends StatefulWidget {
  final String? title;
  final Widget? content;
  final List<Widget>? actions;
  final bool dismissble;

  const BootstrapModal(
      {super.key, this.title, this.content, this.actions, this.dismissble = false});

  @override
  State<BootstrapModal> createState() => _BootstrapModalState();
}

class _BootstrapModalState extends State<BootstrapModal> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: secondary.withOpacity(0.5),
      title: Container(
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1.0)),
        ),
        child: Row(
          children: [
            Expanded(
                child: BootstrapHeading.h2(text: widget.title != null ? widget.title! : 'Title')),
            widget.dismissble
                ? IconButton(
                    icon: const Icon(Icons.close_sharp, color: Colors.white),
                    iconSize: 18,
                    onPressed: () => Navigator.of(context).pop(),
                  )
                : const SizedBox(),
          ],
        ),
      ),
      content: widget.content != null
          ? Container(
              decoration: const BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color(0xFFE5E5E5),
                    width: 1.0,
                  ),
                ),
              ),
              padding: const EdgeInsets.all(15),
              child: widget.content,
            )
          : null,
      actions: widget.actions,
    );
  }
}

enum BootstrapModalSize { large, medium, small }
