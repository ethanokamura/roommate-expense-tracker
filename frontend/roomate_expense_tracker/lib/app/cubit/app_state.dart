part of 'app_cubit.dart';

/// Defines possible status of app.
enum AppStatus {
  unauthenticated,
  needsUsername,
  authenticated,
  authenticatedAsAdmin,
  loading,
  failure,
}

/// Auth Status Extenstions for public access to the current AppStatus
extension AppStatusExtensions on AppStatus {
  bool get isUnauthenticated => this == AppStatus.unauthenticated;
  bool get needsUsername => this == AppStatus.needsUsername;
  bool get isAuthenticated => this == AppStatus.authenticated;
  bool get isFailure => this == AppStatus.failure;
  bool get isLoading => this == AppStatus.loading;
}

/// Keeps track of the apps current state.
final class AppState extends Equatable {
  /// AppState Constructor
  const AppState._({
    required this.status,
    this.failure = UsersFailure.empty,
  });

  /// Private setters for AppStatus
  const AppState.unauthenticated() : this._(status: AppStatus.unauthenticated);
  const AppState.authenticated() : this._(status: AppStatus.authenticated);
  const AppState.authenticatedAsAdmin()
      : this._(status: AppStatus.authenticatedAsAdmin);
  const AppState.loading() : this._(status: AppStatus.loading);

  // const AppState.authenticated(Users user)
  //     : this._(
  //         status: AppStatus.authenticated,
  //         user: user,
  //       );

  // const AppState.failure({
  //   required CredentialsFailure failure,
  //   required Users user,
  // }) : this._(
  //         status: AppStatus.failure,
  //         user: user,
  //         failure: failure,
  //       );

  // /// State properties
  final AppStatus status;
  // final UserData user;
  final UsersFailure failure;

  @override
  List<Object?> get props => [status, failure];
}

/// Public getters for AppState
extension AppStateExtensions on AppState {
  bool get isUnauthenticated => status.isUnauthenticated;
  bool get isAuthenticated => status.isAuthenticated;
  bool get isFailure => status.isFailure;
  bool get isLoading => status.isLoading;
}
