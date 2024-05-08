import 'dart:async';

import 'package:shared_app/domain.dart';
import 'package:shared_app/presentation.dart';

final class CollectionLogic extends Logic {
  CollectionLogic(super.sp);

  final datesDataNotifier = DataNotifier<List<Date>>();
  final selectedDateNotifier = ValueNotifier<Date?>(null);

  final linksDataNotifier = DataNotifier<List<List<CollectionLink>>>();

  @override
  Future<void> initLogic() async {
    super.initLogic();

    await datesDataNotifier.loadData(
      getRequired<CollectionLinkService>().getDates(),
    );
    datesDataNotifier.value.when(
      success: (dates, _) {
        if (dates.isEmpty) return;
        selectDate(dates
            .where((element) => element.dateTime.isBefore(DateTime.now()))
            .first);
      },
    );
  }

  @override
  void disposeLogic() {
    datesDataNotifier.dispose();
    selectedDateNotifier.dispose();
    linksDataNotifier.dispose();
    super.disposeLogic();
  }

  Future<void> selectNextDate() async {
    final dates = datesDataNotifier.value.when(
      success: (dates, _) => dates,
    );

    if (dates == null || dates.isEmpty) return;

    final index = dates.indexOf(selectedDateNotifier.value!);
    if (index == 0) return;

    await selectDate(dates[index - 1]);
  }

  Future<void> selectPreviousDate() async {
    final dates = datesDataNotifier.value.when(
      success: (dates, _) => dates,
    );

    if (dates == null || dates.isEmpty) return;

    final index = dates.indexOf(selectedDateNotifier.value!);
    if (index == dates.length - 1) return;

    await selectDate(dates[index + 1]);
  }

  Future<void> selectDate(Date date) async {
    if (selectedDateNotifier.value == date) return;
    selectedDateNotifier.value = date;

    linksDataNotifier.value = DataStateLoading();
    final data =
        await getRequired<CollectionLinkService>().getLinksByDate(date);

    data.when(
      success: (data) {
        final items = [
          [
            data[0],
            data[1],
            data[2],
          ],
          [
            data[3],
            data[4],
            data[5],
            data[6],
          ],
          [
            data[7],
            data[8],
            data[9],
          ],
          [
            data[10],
            data[11],
            data[12],
            data[13],
            data[14],
            data[15],
            data[16],
            data[17],
          ],
        ];

        linksDataNotifier.value = DataStateSuccess(items);
      },
      failure: (failure) {
        linksDataNotifier.value = DataStateFailed(failure);
      },
    );
  }
}
