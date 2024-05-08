import 'package:shared_app/presentation.dart';

final class SmoothListView extends StatefulWidget {
  const SmoothListView({
    Key? key,
    required this.children,
  }) : super(key: key);

  final List<Widget> children;

  @override
  State<SmoothListView> createState() => _SmoothListViewState();
}

final class _SmoothListViewState extends State<SmoothListView> {
  final controller = ScrollController();

  @override
  void initState() {
    super.initState();
    controller.addListener(() {
      // ignore: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member
      final ScrollActivity? activity = controller.position.activity;
      if (activity is BallisticScrollActivity) {
        final Simulation? simulation =
            controller.position.physics.createBallisticSimulation(
          controller.position,
          activity.velocity,
        );
        if (simulation != null) {
          final double predictedPixels =
              simulation.x(100); // Adjust the duration as needed
          final double minPixels = controller.position.minScrollExtent;
          final double maxPixels = controller.position.maxScrollExtent;
          final double threshold = 20.0; // Adjust this threshold as needed
          final double velocity = activity.velocity.abs();
          final double distance = (predictedPixels - minPixels <= threshold)
              ? predictedPixels - minPixels
              : maxPixels - predictedPixels;
          final double duration =
              (distance / velocity) * 1000; // Convert to milliseconds
          if (predictedPixels - minPixels <= threshold) {
            controller.animateTo(
              minPixels,
              duration: Duration(milliseconds: duration.toInt()),
              curve: Curves.linearToEaseOut,
            );
          } else if (maxPixels - predictedPixels <= threshold) {
            controller.animateTo(
              maxPixels,
              duration: Duration(milliseconds: duration.toInt()),
              curve: Curves.linearToEaseOut,
            );
          }
        }
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      controller: controller,
      children: widget.children,
    );
  }
}
