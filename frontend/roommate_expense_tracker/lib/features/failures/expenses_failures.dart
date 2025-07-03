import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:expenses_repository/expenses_repository.dart';

////////////////////////////////////////////////////////////////////////////
//                                                                        //
//                           PERFECT LINE LLC                             //
//                                                                        //
//           THIS FILE IS AUTO-GENERATED. DO NOT EDIT MANUALLY.           //
//                                                                        //
//  Any changes to this file will be overwritten the next time the code   //
//  is regenerated. If you need to modify behavior, update the source     //
//                         template instead.                              //
//                                                                        //
//                Generated on: 2025-07-02 02:59:11 UTC                   //
//                                                                        //
////////////////////////////////////////////////////////////////////////////



/// Failure controller for [ExpensesRepository]
/// Handles failures from the [ExpensesRepository]
/// Requires a [failureSelector] to handle the specifc failure correctly
/// Takes in the [S] state of the cubit
/// Wrapper for the given [child] widget
BlocListener<C, S> listenForExpensesFailures<C extends Cubit<S>, S>({
  required ExpensesFailure Function(S state) failureSelector,
  required bool Function(S state) isFailureSelector,
  required Widget child,
}) {
  // Listens for failures
  return BlocListener<C, S>(
    listenWhen: (previous, current) =>
        !isFailureSelector(previous) && isFailureSelector(current),
    listener: (context, state) {
      if (isFailureSelector(state)) {
        final failure = failureSelector(state);
        // Build failure message
        final message = switch (failure) {
          EmptyFailure() => 'ExpensesFailure: Empty',
          CreateFailure() => 'ExpensesFailure: Create',
          ReadFailure() => 'ExpensesFailure: Read',
          UpdateFailure() => 'ExpensesFailure: Update',
          DeleteFailure() => 'ExpensesFailure: Delete',
          _ => 'ExpensesFailure: Unknown',
        };
        // Display snackbar message
        context.showSnackBar(message);
      }
    },
    // Display child widget
    child: child,
  );
}
