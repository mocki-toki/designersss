import 'package:shared_app/presentation.dart';

final class LoadingDecorator extends StatelessWidget {
  final bool isLoading;
  final Widget child;

  const LoadingDecorator({
    super.key,
    required this.isLoading,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IgnorePointer(
          ignoring: isLoading,
          child: child,
        ),
        if (isLoading)
          ColoredBox(
            color: Colors.white.withOpacity(0.5),
            child: Center(
              child: CircularProgressIndicator(),
            ),
          ),
      ],
    );
  }
}
