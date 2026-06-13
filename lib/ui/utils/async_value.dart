sealed class AsyncValue<T> {
  const AsyncValue();
}

class AsyncLoading<T> extends AsyncValue<T> {
  const AsyncLoading();
}

class AsyncData<T> extends AsyncValue<T> {
  final T data;
  const AsyncData(this.data);
}

class AsyncError<T> extends AsyncValue<T> {
  final Object error;
  final StackTrace? stackTrace;

  const AsyncError(this.error, [this.stackTrace]);
}
