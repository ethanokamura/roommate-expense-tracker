import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:roommate_expense_tracker/features/home/view/bottom_nav_bar.dart';
// import 'package:users_repository/users_repository.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static MaterialPage<dynamic> page() =>
      const MaterialPage<void>(child: HomePage());

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (_) => NavBarController(),
      child: const Scaffold(
        body: HomeBody(),
        bottomNavigationBar: BottomNavBar(),
      ),
    );
  }
}

class HomeBody extends StatelessWidget {
  const HomeBody({super.key});
  @override
  Widget build(BuildContext context) {
    // final userId = context.read<UsersRepository>().users.userId;
    final pageController = context.watch<NavBarController>();

    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        Placeholder(),
        Placeholder(),
        Placeholder(),
        // const ExplorePage(),
        // Center(child: CustomText(text: context.l10n.create, style: titleText)),
        // ProfilePage(userId: userId),
      ],
    );
  }
}
