import 'dart:async';

abstract interface class External<R, P> {
  Future<R> request(P params);

  FutureOr<void> close();

  void initialize();
}
