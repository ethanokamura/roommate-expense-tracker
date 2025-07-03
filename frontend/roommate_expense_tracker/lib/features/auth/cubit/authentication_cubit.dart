import 'package:app_core/app_core.dart';
import 'package:users_repository/users_repository.dart';

part 'authentication_state.dart';

/// Allows the user to interact authentication servcies.
class AuthCubit extends Cubit<AuthState> {
  AuthCubit({required UsersRepository usersRepository})
      : _usersRepository = usersRepository,
        super(const AuthState.initial());

  final UsersRepository _usersRepository;

  Future<void> signIn() async {
    emit(state.fromLoading());
    try {
      await _usersRepository.signInWithGoogleFirebase();
      emit(state.fromLoaded());
    } on UsersFailure catch (failure) {
      emit(state.fromFailure(failure));
    }
  }
}
