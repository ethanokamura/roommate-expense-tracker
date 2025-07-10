import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:expenses_repository/expenses_repository.dart';

class ExpenseSplitsCard extends StatelessWidget {
  const ExpenseSplitsCard({required this.split, required this.paid, super.key});
  final ExpenseSplit split;
  final bool paid;
  @override
  Widget build(BuildContext context) {
    return DefaultContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text:
                    '${split.memberId.length > 20 ? split.memberId.substring(0, 20) : split.memberId}...',
                style: AppTextStyles.primary,
              ),
              CustomText(
                text: formatCurrency(split.amountOwed),
                style: AppTextStyles.primary,
                color: paid
                    ? context.theme.successColor
                    : context.theme.errorColor,
              ),
            ],
          ),
          CustomText(
            text: split.paidOn != null &&
                    startOfDay(split.paidOn!) != startOfDay(DateTime.now())
                ? 'Paid On: ${DateFormatter.formatTimestamp(split.paidOn!)}'
                : 'Expense has not been paid.',
            style: AppTextStyles.secondary,
          ),
        ],
      ),
    );
  }
}
