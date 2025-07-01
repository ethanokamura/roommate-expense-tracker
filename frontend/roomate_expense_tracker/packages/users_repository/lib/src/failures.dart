import 'package:app_core/app_core.dart';

class UsersFailure extends Failure {
  const UsersFailure._();

  factory UsersFailure.fromCreate() => const CreateFailure();
  factory UsersFailure.fromGet() => const ReadFailure();
  factory UsersFailure.fromUpdate() => const UpdateFailure();
  factory UsersFailure.fromDelete() => const DeleteFailure();

  static const empty = EmptyFailure();
}

class CreateFailure extends UsersFailure {
  const CreateFailure() : super._();
}

class ReadFailure extends UsersFailure {
  const ReadFailure() : super._();
}

class UpdateFailure extends UsersFailure {
  const UpdateFailure() : super._();
}

class DeleteFailure extends UsersFailure {
  const DeleteFailure() : super._();
}

class EmptyFailure extends UsersFailure {
  const EmptyFailure() : super._();
}
