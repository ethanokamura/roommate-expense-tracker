import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
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
    debugPrint('home pages');
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
        ExpensesDashboard(houseId: '1234'),
        HouseDashboard(),
        UserDashboard(),
      ],
    );
  }
}
