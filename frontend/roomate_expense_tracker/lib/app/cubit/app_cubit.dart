import 'package:app_core/app_core.dart';
import 'package:credentials_repository/credentials_repository.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  /// Constructs AppCubit
  /// Takes in CredentialsRepository instance and sets the initial AppState.
  AppCubit({
    required CredentialsRepository credentialsRepository,
  })  : _credentialsRepository = credentialsRepository,
        super(_initialState(credentialsRepository));

  final CredentialsRepository _credentialsRepository;

  /// Sets initial auth state for the app
  /// Checks to see the current status of user authetication
  static AppState _initialState(CredentialsRepository credentialRepository) {
    return credentialRepository.authenticated
        ? const AppState.authenticated()
        : const AppState.unauthenticated();
  }

  void verifyAuthentication() {
    _credentialsRepository.authenticated
        ? emit(const AppState.authenticated())
        : emit(const AppState.unauthenticated());
  }
}
