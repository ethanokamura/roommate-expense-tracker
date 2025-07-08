import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:roommate_expense_tracker/features/users/users.dart';
import 'package:roommate_expense_tracker/features/failures/users_failures.dart';

class UsersCubitWrapper extends StatelessWidget {
  const UsersCubitWrapper({
    required this.builder,
    super.key,
  });
  final Widget Function(BuildContext context, UsersState state) builder;

  @override
  Widget build(BuildContext context) {
    return listenForUsersFailures<UsersCubit, UsersState>(
      failureSelector: (state) => state.failure,
      isFailureSelector: (state) => state.isFailure,
      child: BlocBuilder<UsersCubit, UsersState>(
        builder: builder,
      ),
    );
  }
}
