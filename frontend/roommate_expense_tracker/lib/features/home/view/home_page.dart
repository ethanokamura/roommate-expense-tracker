import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:roommate_expense_tracker/features/expenses/pages/create_expense_page.dart';
import 'package:roommate_expense_tracker/features/expenses/pages/expenses_dashboard.dart';
import 'package:roommate_expense_tracker/features/home/view/bottom_nav_bar.dart';
import 'package:roommate_expense_tracker/features/houses/pages/pages.dart';
import 'package:roommate_expense_tracker/features/users/pages/user_dashboard.dart';
import 'package:roommate_expense_tracker/theme/theme_button.dart';
import 'package:users_repository/users_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static MaterialPage<dynamic> page() =>
      const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (_) => NavBarController(),
      child: DefaultPageView(
        title: 'RET',
        body: const HomeBody(),
        actions: [
          const ThemeButton(),
          AppBarButton(
            icon: Icons.exit_to_app,
            onTap: () async => context.read<UsersRepository>().signOut(),
          )
        ],
        floatingActionButton: FloatingActionTransitionContainer(
          page: const CreateExpensePage(memberId: '1234'),
          icon: defaultIconStyle(
            context,
            AppIcons.add,
            context.theme.backgroundColor,
            size: 24,
          ),
        ),
        bottomNavigationBar: const BottomNavBar(),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});
  @override
  Widget build(BuildContext context) {
    // final userEmail = context.read<UsersRepository>().currentUser!.email;
    final pageController = context.watch<NavBarController>();

    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        ExpensesDashboard(houseId: 'e4ifg4d3-3g4f-7i5g-b1i2-2e3d4f5g6h7i'),
        HouseDashboard(),
        UserDashboard(),
      ],
    );
  }
}
