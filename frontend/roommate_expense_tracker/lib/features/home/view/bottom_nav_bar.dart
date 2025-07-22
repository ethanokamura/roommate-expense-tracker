import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
// import 'package:roommate_expense_tracker/features/create/create.dart';

enum NavBarItem { home, expenses, profile }

extension NavBarItemExtensions on NavBarItem {
  bool get isHome => this == NavBarItem.home;
}

final class NavBarController extends PageController {
  NavBarController({NavBarItem initialItem = NavBarItem.home})
      : _notifier = ValueNotifier<NavBarItem>(initialItem),
        super(initialPage: initialItem.index) {
    _notifier.addListener(_listener);
  }

  final ValueNotifier<NavBarItem> _notifier;

  NavBarItem get item => _notifier.value;
  set item(NavBarItem newItem) => _notifier.value = newItem;

  void _listener() {
    jumpToPage(item.index);
  }

  @override
  void dispose() {
    _notifier
      ..removeListener(_listener)
      ..dispose();
    super.dispose();
  }
}

class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final navBarController = context.watch<NavBarController>();
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      onTap: (index) async {
        navBarController.item = NavBarItem.values[index];
      },
      currentIndex: context
          .select((NavBarController controller) => controller.item.index),
      selectedItemColor: context.theme.accentColor,
      backgroundColor: context.theme.colorScheme.surface,
      showSelectedLabels: true,
      showUnselectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(AppIcons.money, size: 20),
          label: 'Expenses',
        ),
        BottomNavigationBarItem(
          icon: Icon(AppIcons.house, size: 20),
          label: 'House',
        ),
        BottomNavigationBarItem(
          icon: Icon(AppIcons.user, size: 20),
          label: 'Profile',
        ),
      ],
    );
  }
}
