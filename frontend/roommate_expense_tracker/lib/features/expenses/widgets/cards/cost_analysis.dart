import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:expenses_repository/expenses_repository.dart';

class CostAnalysisWidget extends StatelessWidget {
  const CostAnalysisWidget({
    required this.field,
    required this.value,
    required this.token,
    super.key,
  });

  final String field;
  final String value;
  final String token;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future:
          context.read<ExpensesRepository>().fetchWeeklyExpensesWithForeignKey(
                key: field,
                value: value,
                token: token,
              ),
      builder: (context, snapshot) {
        debugPrint(snapshot.data.toString());
        return Placeholder();
      },
    );
  }
}
