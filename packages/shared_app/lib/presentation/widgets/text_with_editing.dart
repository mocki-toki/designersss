import 'package:shared_app/presentation.dart';

final class TextWithEditing extends StatefulWidget {
  const TextWithEditing(
    this.content, {
    super.key,
    this.changingText,
    required this.onChanged,
    required this.style,
    required this.maxLines,
  });

  final String content;
  final String? changingText;
  final ValueChanged<String>? onChanged;
  final TextStyle style;
  final int maxLines;

  @override
  State<TextWithEditing> createState() => _TextWithEditingState();
}

final class _TextWithEditingState extends State<TextWithEditing> {
  var isEditable = false;
  final focusNode = FocusNode();
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    focusNode.addListener(() {
      setState(() => isEditable = focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(context) {
    if (isEditable) {
      return EditableText(
        focusNode: focusNode,
        controller: controller,
        style: widget.style,
        cursorColor: Colors.black,
        backgroundCursorColor: Colors.black,
        selectionColor: Colors.black12,
        minLines: 1,
        maxLines: widget.maxLines,
        onChanged: widget.onChanged,
      );
    } else {
      return Clickable(
        onTap: widget.onChanged == null
            ? null
            : () {
                controller.text = widget.changingText ?? widget.content;
                focusNode.requestFocus();

                setState(() => isEditable = true);
              },
        isDisabling: false,
        child: Text(
          widget.content,
          style: widget.style,
          overflow: TextOverflow.ellipsis,
          maxLines: widget.maxLines,
        ),
      );
    }
  }
}
