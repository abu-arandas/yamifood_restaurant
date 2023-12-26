import '/exports.dart';

class BootstrapModal extends StatelessWidget {
  final String? title;
  final Widget? content;
  final List<Widget>? actions;
  final bool dismissble;

  const BootstrapModal({super.key, this.title, this.content, this.actions, this.dismissble = false});

  @override
  Widget build(BuildContext context) => AlertDialog(
        backgroundColor: secondary.withOpacity(0.5),
        title: Container(
          padding: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            border: Border(bottom: BorderSide(color: Theme.of(context).dividerColor, width: 1.0)),
          ),
          child: Row(
            children: [
              Expanded(child: Text(title ?? 'Title', style: TextStyle(fontSize: h2))),
              dismissble
                  ? IconButton(
                      icon: const Icon(Icons.close_sharp, color: Colors.white),
                      iconSize: 18,
                      onPressed: () => Navigator.of(context).pop(),
                    )
                  : const SizedBox(),
            ],
          ),
        ),
        content: content != null
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
                child: content,
              )
            : null,
        actions: actions,
      );
}

enum BootstrapModalSize { large, medium, small }
