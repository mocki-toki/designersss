import 'package:shared_app/domain.dart';
import 'package:shared_app/presentation.dart';

typedef ListDataState<T> = DataState<List<T>>;

final class SeveralDataList {
  const SeveralDataList(this._dataList);

  final List _dataList;

  T get<T>() {
    try {
      return _dataList.whereType<T>().first;
    } catch (e) {
      throw Exception('Data type $T is not found');
    }
  }
}

extension SeveralDataNotifiers on List<DataNotifier> {
  // TODO: сделать виджеты
  Widget when({
    Widget Function()? initial,
    Widget Function()? loading,
    required Widget Function(SeveralDataList dataList) success,
    Widget Function(Failure failure)? failed,
  }) {
    List dataList = [];

    return _recursiveWhen(
      index: 0,
      initial: initial,
      loading: loading,
      success: success,
      failed: failed,
      dataList: dataList,
    );
  }

  Widget _recursiveWhen({
    required int index,
    Widget Function()? initial,
    Widget Function()? loading,
    required Widget Function(SeveralDataList dataList) success,
    Widget Function(Failure failure)? failed,
    required List dataList,
  }) {
    if (index == length) {
      if (dataList.isEmpty)
        return initial?.call() ?? DataStateInitial().stateToWidget(null);

      return success(SeveralDataList(dataList));
    }

    return this[index].builder(
      builder: (context, state, child) {
        if (state.isFailed) {
          return failed?.call(state.asFailed!.failure) ??
              state.stateToWidget(context);
        } else if (state.isInitial && initial != null) {
          return initial();
        } else if (state.isLoading) {
          return loading?.call() ?? state.stateToWidget(context);
        } else if (state.isSuccess) {
          dataList.add(state.asSuccess!.data);
        }

        return _recursiveWhen(
          index: index + 1,
          initial: initial,
          loading: loading,
          success: success,
          failed: failed,
          dataList: dataList,
        );
      },
    );
  }
}

final class DataNotifier<T> extends ValueNotifier<DataState<T>> {
  DataNotifier([DataState<T> state = const DataStateInitial()]) : super(state);

  Widget when({
    Widget Function()? initial,
    Widget Function()? loading,
    required Widget Function(T data) success,
    Widget Function(Failure failure)? failed,
  }) {
    return ValueListenableBuilder<DataState<T>>(
      valueListenable: this,
      builder: (context, state, child) {
        if (state.isInitial) {
          return initial?.call() ?? state.stateToWidget(context);
        } else if (state.isLoading) {
          return loading?.call() ?? state.stateToWidget(context);
        } else if (state.isSuccess) {
          return success(state.asSuccess!.data);
        } else if (state.isFailed) {
          return failed?.call(state.asFailed!.failure) ??
              state.stateToWidget(context);
        } else {
          throw UnsupportedError('Unsupported state: $state');
        }
      },
    );
  }

  Widget builder({
    required Widget Function(
      BuildContext context,
      DataState<T> state,
      Widget? child,
    ) builder,
    Widget? child,
  }) {
    return ValueListenableBuilder<DataState<T>>(
      valueListenable: this,
      builder: builder,
      child: child,
    );
  }

  Future<void> loadData(
    Future<DataOrFailure<T>> from, {
    void Function(T data)? onSuccess,
    void Function(Failure failure)? onFailure,
  }) async {
    value = const DataStateLoading();
    notifyListeners();

    final result = await from;

    result.when(
      success: (data) {
        value = DataStateSuccess(data);
        onSuccess?.call(data);
      },
      failure: (failure) {
        value = DataStateFailed(failure);
        onFailure?.call(failure);
      },
    );

    notifyListeners();
  }
}

sealed class DataState<T> {
  const DataState();

  bool get isInitial => this is DataStateInitial<T>;
  bool get isLoading => this is DataStateLoading<T>;
  bool get isSuccess => this is DataStateSuccess<T>;
  bool get isLoadingMore => this is DataStateLoadingMore<T>;
  bool get isFailed => this is DataStateFailed<T>;

  DataStateInitial<T>? get asInitial =>
      this is DataStateInitial<T> ? this as DataStateInitial<T> : null;
  DataStateLoading<T>? get asLoading =>
      this is DataStateLoading<T> ? this as DataStateLoading<T> : null;
  DataStateSuccess<T>? get asSuccess =>
      this is DataStateSuccess<T> ? this as DataStateSuccess<T> : null;
  DataStateLoadingMore<T>? get asLoadingMore =>
      this is DataStateLoadingMore<T> ? this as DataStateLoadingMore<T> : null;
  DataStateFailed<T>? get asFailed =>
      this is DataStateFailed<T> ? this as DataStateFailed<T> : null;

  Widget stateToWidget<T>(BuildContext? context) {
    switch (this) {
      case DataStateInitial<T>():
        return const SizedBox.shrink();
      case DataStateLoading<T>():
        return Center(child: const CircularProgressIndicator());
      case DataStateFailed<T>(failure: final failure):
        if (failure is NetworkFailure)
          return Center(
            child: MessageBanner(
              message: context == null
                  ? failure.toString()
                  : failure.toLocalizedString(context),
              iconData: FontAwesomeIcons.server,
            ),
          );
        return Center(
            child: Text(
          context == null
              ? failure.toString()
              : failure.toLocalizedString(context),
        ));
      default:
        throw UnsupportedError('Unsupported state: $this');
    }
  }

  A? when<A>({
    A Function()? initial,
    A Function()? loading,
    required A Function(T data, Failure? failure) success,
    A Function(T data)? loadingMore,
    A Function(Failure failure)? failed,
  }) {
    switch (this) {
      case DataStateInitial<T>():
        return initial?.call();
      case DataStateLoading<T>():
        return loading?.call();
      case DataStateSuccess<T>(data: final data, failure: final failure):
        return success(data, failure);
      case DataStateLoadingMore<T>(data: final data):
        return loadingMore?.call(data);
      case DataStateFailed<T>(failure: final failure):
        return failed?.call(failure);
      default:
        throw UnsupportedError('Unsupported state: $this');
    }
  }
}

final class DataStateInitial<T> extends DataState<T> {
  const DataStateInitial();
}

final class DataStateLoading<T> extends DataState<T> {
  const DataStateLoading();
}

final class DataStateSuccess<T> extends DataState<T> {
  final T data;
  final Failure? failure;

  const DataStateSuccess(this.data, [this.failure]);
}

final class DataStateLoadingMore<T> extends DataState<T> {
  final T data;

  const DataStateLoadingMore(this.data);
}

final class DataStateFailed<T> extends DataState<T> {
  final Failure failure;

  const DataStateFailed(this.failure);
}
