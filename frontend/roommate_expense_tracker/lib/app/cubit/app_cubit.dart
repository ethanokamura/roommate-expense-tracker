import 'package:app_core/app_core.dart';
import 'package:users_repository/users_repository.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppState> {
  /// Constructs AppCubit
  /// Takes in CredentialsRepository instance and sets the initial AppState.
  AppCubit({
    required UsersRepository usersRepository,
  })  : _usersRepository = usersRepository,
        super(_initialState(usersRepository));

  final UsersRepository _usersRepository;

  /// Sets initial auth state for the app
  /// Checks to see the current status of user authetication
  static AppState _initialState(UsersRepository usersRepository) {
    return usersRepository.authenticated
        ? const AppState.authenticated()
        : const AppState.unauthenticated();
  }

  void verifyAuthentication() {
    _usersRepository.authenticated
        ? emit(const AppState.authenticated())
        : emit(const AppState.unauthenticated());
  }

  void selectedHouse({required String houseId}) {
    _usersRepository.userHouseId(
      houseId: houseId,
      userId: _usersRepository.users.userId!,
    );
    emit(const AppState.authenticatedWithHouse());
  }
}
