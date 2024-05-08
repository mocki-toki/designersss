import 'package:shared_app/presentation.dart';

final class MessageBanner extends StatelessWidget {
  const MessageBanner({
    Key? key,
    required this.message,
    required this.iconData,
  }) : super(key: key);

  final String message;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          iconData,
          size: 40,
        ),
        const SizedBox(height: 20),
        Text(
          message,
          style: TextStyle(
            fontFamily: 'Cygre',
            fontWeight: FontWeight.w500,
            fontSize: 18,
          ),
        ),
      ],
    );
  }
}
