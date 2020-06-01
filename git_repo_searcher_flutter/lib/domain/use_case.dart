/// Clean Arch `UseCase` implementation.
/// ex.:
/// ```
/// // parameter type integer
/// class GetFooUseCase extends UseCase<int, List<Foo>>{ ... }
/// ...
/// // no parameter needed
/// class GetVoidUseCase extends UseCase<void, List<Foo>{ ... }
///
/// ```
abstract class UseCase<Params, Result> {
  Future<Result> execute([Params params]);
}
