import 'package:shared_app/presentation.dart';

abstract class WidgetWithLogic<T extends Logic> extends StatefulWidget {
  const WidgetWithLogic({super.key});

  T logicBuilder(BuildContext context);

  Widget build(BuildContext context, T logic);

  @override
  _WidgetWithLogicState<T> createState() => _WidgetWithLogicState<T>();
}

final class _WidgetWithLogicState<T extends Logic>
    extends State<WidgetWithLogic<T>> {
  late T logic;

  @override
  void initState() {
    super.initState();
    logic = widget.logicBuilder(context);
    logic.initLogic();
  }

  @override
  void dispose() {
    logic.disposeLogic();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Provider<T>.value(
      value: logic,
      child: widget.build(context, logic),
    );
  }
}
