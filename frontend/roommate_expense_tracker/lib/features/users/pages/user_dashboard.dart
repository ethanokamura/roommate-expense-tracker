import 'package:app_ui/app_ui.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomText(
            text: 'User Dashboard',
            style: AppTextStyles.title,
          ),
          //Nickname:
          CustomText(
            text: 'Nickname: Temp',//Pull from the database. And then display it here.
            //users can eedit their nickname.
            style: AppTextStyles.primary,
          ),
          //Houses:
          CustomText(
            text: 'Houses: Temp',//Pull from the database. And then display it here.
            //use the backend join query to get the houses the user is part of.
            style: AppTextStyles.primary,
          ),
          //Expense History Button
          CustomButton(
            text: 'Expense History',
            onTap: null,
          ),
          //Logout Button
          CustomButton(
            text: 'Logout',
            onTap: null,
          ),
          //Delete Account Button
          CustomButton(
            text: 'Delete Account',
            onTap: null,
          ),
        ],
      ),
    );
  }
}
