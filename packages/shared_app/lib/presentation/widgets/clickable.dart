import 'package:shared_app/presentation.dart';

final class Clickable extends StatefulWidget {
  const Clickable({
    Key? key,
    required this.child,
    required this.onTap,
    this.behavior = HitTestBehavior.opaque,
    this.isDisabling = true,
  }) : super(key: key);

  final Widget child;
  final VoidCallback? onTap;
  final HitTestBehavior behavior;
  final bool isDisabling;

  @override
  State<Clickable> createState() => _ClickableState();
}

final class _ClickableState extends State<Clickable> {
  bool isHovered = false;
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return DisablingDecorator(
      isDisabled: widget.isDisabling && widget.onTap == null,
      child: MouseRegion(
        onEnter: (_) => setState(() => isHovered = widget.onTap != null),
        onExit: (_) => setState(() => isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => isPressed = true),
          onTapUp: (_) => setState(() => isPressed = false),
          onTapCancel: () => setState(() => isPressed = false),
          behavior: widget.behavior,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            opacity: isHovered ? 0.7 : 1,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
