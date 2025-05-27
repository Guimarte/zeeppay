abstract class CommonState {}

class InitialState extends CommonState {}

class LoadingState extends CommonState {}

class SuccessState<T> extends CommonState {
  final T data;

  SuccessState(this.data);
}

class FailureState extends CommonState {
  final String message;

  FailureState(this.message);
}
