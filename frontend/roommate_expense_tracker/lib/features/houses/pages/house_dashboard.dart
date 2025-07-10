import 'package:app_ui/app_ui.dart';
import 'roommate_management_page.dart';

class HouseDashboard extends StatelessWidget {
  const HouseDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CustomText(
            text: 'House Dashboard',
            style: AppTextStyles.title,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RoommateManagementPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary, 
              foregroundColor: Theme.of(context).colorScheme.onPrimary, // color
            ),
            child: const Text("Manage Roommates"),
          ),
        ],
      ),
    );
  }
}
