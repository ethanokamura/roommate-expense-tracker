import 'package:app_core/app_core.dart';

class CredentialsFailure extends Failure {
  const CredentialsFailure._();

  // user data retrieval
  factory CredentialsFailure.fromCreate() => const CreateFailure();
  factory CredentialsFailure.fromGet() => const GetFailure();
  factory CredentialsFailure.fromUpdate() => const UpdateFailure();
  factory CredentialsFailure.fromDelete() => const DeleteFailure();

  // auth
  factory CredentialsFailure.fromAuthChanges() => const AuthChangesFailure();
  factory CredentialsFailure.fromSignOut() => const SignOutFailure();
  factory CredentialsFailure.fromSignIn() => const SignInFailure();

  static const empty = EmptyFailure();
}

class EmptyFailure extends CredentialsFailure {
  const EmptyFailure() : super._();
}

class AuthChangesFailure extends CredentialsFailure {
  const AuthChangesFailure() : super._();

  @override
  bool get needsReauthentication => true;
}

class SignInFailure extends CredentialsFailure {
  const SignInFailure() : super._();
}

class SignOutFailure extends CredentialsFailure {
  const SignOutFailure() : super._();
}

class CreateFailure extends CredentialsFailure {
  const CreateFailure() : super._();
}

class GetFailure extends CredentialsFailure {
  const GetFailure() : super._();
}

class UpdateFailure extends CredentialsFailure {
  const UpdateFailure() : super._();
}

class DeleteFailure extends CredentialsFailure {
  const DeleteFailure() : super._();
}
