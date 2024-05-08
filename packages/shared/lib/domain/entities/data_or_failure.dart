import 'package:shared/domain.dart';

final class DataOrFailure<T> {
  const DataOrFailure(this.data, this.failure);

  const DataOrFailure._success(T data) : this(data, null);
  const DataOrFailure._failure(Failure failure) : this(null, failure);

  final T? data;
  final Failure? failure;

  R when<R>({
    required R Function(T data) success,
    required R Function(Failure failure) failure,
  }) {
    if (this.failure != null) {
      return failure(this.failure!);
    } else {
      return success(this.data as T);
    }
  }

  void onSuccess(void Function(T data) success) {
    if (this.data != null) {
      success(this.data!);
    }
  }

  void onFailure(void Function(Failure failure) failure) {
    if (this.failure != null) {
      failure(this.failure!);
    }
  }
}

typedef SuccessOrFailure = DataOrFailure<void>;
typedef ListDataOrFailure<T> = DataOrFailure<List<T>>;

DataOrFailure<T> successful<T>(T data) => DataOrFailure<T>._success(data);
DataOrFailure<T> failed<T>(Failure failure) =>
    DataOrFailure<T>._failure(failure);
