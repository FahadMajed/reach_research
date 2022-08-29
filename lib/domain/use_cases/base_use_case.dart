abstract class BaseUseCase<T> {
  BaseUseCase();
}

abstract class UseCase<T, P> extends BaseUseCase<T> {
  UseCase();

  Future<T> call(P params);
}

abstract class NoParamsUseCase<T> extends BaseUseCase<T> {
  NoParamsUseCase();

  Future<T> call();
}
