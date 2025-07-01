import 'package:app_core/app_core.dart';

class HousesFailure extends Failure {
  const HousesFailure._();

  factory HousesFailure.fromCreate() => const CreateFailure();
  factory HousesFailure.fromGet() => const ReadFailure();
  factory HousesFailure.fromUpdate() => const UpdateFailure();
  factory HousesFailure.fromDelete() => const DeleteFailure();

  static const empty = EmptyFailure();
}

class CreateFailure extends HousesFailure {
  const CreateFailure() : super._();
}

class ReadFailure extends HousesFailure {
  const ReadFailure() : super._();
}

class UpdateFailure extends HousesFailure {
  const UpdateFailure() : super._();
}

class DeleteFailure extends HousesFailure {
  const DeleteFailure() : super._();
}

class EmptyFailure extends HousesFailure {
  const EmptyFailure() : super._();
}
