import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:expenses_repository/expenses_repository.dart';
import 'package:users_repository/users_repository.dart';

class MyTotalExpenses extends StatelessWidget {
  const MyTotalExpenses({super.key});

  @override
  Widget build(BuildContext context) {
    final userRepository = context.read<UsersRepository>();
    return FutureBuilder(
      future: context.read<ExpensesRepository>().fetchMyTotalExpenses(
            houseMemberId: userRepository.getMemberId,
            houseId: userRepository.getHouseId,
            token: userRepository.idToken ?? '',
            forceRefresh: true,
          ),
      builder: (context, snapshot) {
        debugPrint(snapshot.data.toString());
        return CustomText(
          text: formatCurrency(snapshot.data ?? 0.0),
          style: AppTextStyles.primary,
          color: snapshot.data == 0
              ? context.theme.successColor
              : context.theme.errorColor,
        );
      },
    );
  }
}
