part of 'authentication_cubit.dart';

/// Defines possible status for authentication process.
enum AuthStatus {
  initial,
  loading,
  failure,
  loaded,
}

/// Constructs the AuthState and related methods
final class AuthState extends Equatable {
  const AuthState._({
    this.email = '',
    this.status = AuthStatus.initial,
    this.failure = UsersFailure.empty,
  });

  const AuthState.initial() : this._();

  final String email;
  final AuthStatus status;
  final UsersFailure failure;

  @override
  List<Object?> get props => [
        email,
        status,
        failure,
      ];

  /// Allows for easy state manipulation
  AuthState copyWith({
    String? email,
    AuthStatus? status,
    UsersFailure? failure,
  }) {
    return AuthState._(
      email: email ?? this.email,
      status: status ?? this.status,
      failure: failure ?? this.failure,
    );
  }
}

/// Public getters for AuthStatus
extension AuthStateExtensions on AuthState {
  bool get isFailure => status == AuthStatus.failure;
  bool get isSuccess => status == AuthStatus.loaded;
  bool get isLoading => status == AuthStatus.loading;
}

/// Private setters for AuthStatus
extension _AuthStateExtensions on AuthState {
  AuthState fromLoading() => copyWith(
        status: AuthStatus.loading,
      );
  AuthState fromLoaded() => copyWith(
        status: AuthStatus.loaded,
      );
  AuthState fromFailure(UsersFailure failure) => copyWith(
        status: AuthStatus.failure,
        failure: failure,
      );
}
