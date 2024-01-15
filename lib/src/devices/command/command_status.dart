sealed class CommandStatus<S, F> {
  const factory CommandStatus.success(S data) = Success;

  const factory CommandStatus.failure(F data) = Failure;

  Object? get data;
}

final class Success<S, F> implements CommandStatus<S, F> {
  const Success._(this.data);

  const factory Success(final S data) = Success._;

  @override
  final S data;
}

final class Failure<S, F> implements CommandStatus<S, F> {
  const Failure._(this.data);

  const factory Failure(final F data) = Failure._;

  @override
  final F data;
}
