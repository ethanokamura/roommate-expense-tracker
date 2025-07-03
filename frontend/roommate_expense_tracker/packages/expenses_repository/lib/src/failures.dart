import 'package:app_core/app_core.dart';

class ExpensesFailure extends Failure {
  const ExpensesFailure._();

  factory ExpensesFailure.fromCreate() => const CreateFailure();
  factory ExpensesFailure.fromGet() => const ReadFailure();
  factory ExpensesFailure.fromUpdate() => const UpdateFailure();
  factory ExpensesFailure.fromDelete() => const DeleteFailure();

  static const empty = EmptyFailure();
}

class CreateFailure extends ExpensesFailure {
  const CreateFailure() : super._();
}

class ReadFailure extends ExpensesFailure {
  const ReadFailure() : super._();
}

class UpdateFailure extends ExpensesFailure {
  const UpdateFailure() : super._();
}

class DeleteFailure extends ExpensesFailure {
  const DeleteFailure() : super._();
}

class EmptyFailure extends ExpensesFailure {
  const EmptyFailure() : super._();
}
