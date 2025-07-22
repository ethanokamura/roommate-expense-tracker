import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:roommate_expense_tracker/features/expenses/expenses.dart';
import 'package:roommate_expense_tracker/features/home/view/bottom_nav_bar.dart';
import 'package:roommate_expense_tracker/features/houses/houses.dart';
import 'package:roommate_expense_tracker/features/users/users.dart';
import 'package:users_repository/users_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({
    super.key,
  });
  static MaterialPage<dynamic> page() =>
      const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    final houseId = context.read<UsersRepository>().getHouseId;
    final memberId = context.read<UsersRepository>().getMemberId;
    return ListenableProvider(
      create: (_) => NavBarController(),
      child: DefaultPageView(
        body: HomeBody(
          houseId: houseId,
        ),
        floatingActionButton: FloatingActionTransitionContainer(
          page: CreateExpensePage(
            houseId: houseId,
            memberId: memberId,
          ),
          icon: appBarIconStyle(
            context,
            AppIcons.add,
            color: context.theme.backgroundColor,
          ),
        ),
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({
    required this.houseId,
    super.key,
  });

  final String houseId;

  @override
  Widget build(BuildContext context) {
    // final userEmail = context.read<UsersRepository>().currentUser!.email;
    final pageController = context.watch<NavBarController>();
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        const ExpensesDashboard(),
        HouseDashboard(
          houseId: houseId,
          userId: context.read<UsersRepository>().users.userId ?? '',
        ),
        UserDashboard(
          houseId: houseId,
          userId: context.read<UsersRepository>().users.userId ?? '',
        ),
      ],
    );
  }
}
