/// Generic result class for handling success and failure states
sealed class Result<T> {
  const Result();
}

class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

class Failure<T> extends Result<T> {
  const Failure(this.exception);
  final Exception exception;
}

// Extension methods for Result
extension ResultExtension<T> on Result<T> {
  bool get isSuccess => this is Success<T>;
  bool get isFailure => this is Failure<T>;

  T? get data => switch (this) {
    Success(data: final data) => data,
    Failure() => null,
  };

  Exception? get exception => switch (this) {
    Success() => null,
    Failure(exception: final exception) => exception,
  };

  // Transform the data if success, otherwise return the same failure
  Result<U> map<U>(U Function(T) transform) {
    return switch (this) {
      Success(data: final data) => Success(transform(data)),
      Failure(exception: final exception) => Failure(exception),
    };
  }

  // Chain operations that return Result
  Result<U> flatMap<U>(Result<U> Function(T) transform) {
    return switch (this) {
      Success(data: final data) => transform(data),
      Failure(exception: final exception) => Failure(exception),
    };
  }

  // Handle both success and failure cases
  U fold<U>(U Function(Exception) onFailure, U Function(T) onSuccess) {
    return switch (this) {
      Success(data: final data) => onSuccess(data),
      Failure(exception: final exception) => onFailure(exception),
    };
  }
}
