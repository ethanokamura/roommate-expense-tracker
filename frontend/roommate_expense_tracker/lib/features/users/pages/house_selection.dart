import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:roommate_expense_tracker/features/users/cubit/users_cubit.dart';
import 'package:roommate_expense_tracker/features/users/widgets/user_cubit_wrapper.dart';
import 'package:users_repository/users_repository.dart';

class HouseMemberSelectionPage extends StatelessWidget {
  const HouseMemberSelectionPage({super.key});
  static MaterialPage<dynamic> page() =>
      const MaterialPage<void>(child: HouseMemberSelectionPage());
  @override
  Widget build(BuildContext context) {
    final userRepository = context.read<UsersRepository>();
    return DefaultPageView(
      title: 'Select your House',
      body: BlocProvider(
        create: (context) => UsersCubit(
          usersRepository: userRepository,
        )..fetchUsersHouseData(
            userId: userRepository.users.userId!,
            token: userRepository.credentials.credential!.accessToken!,
            orderBy: UserHouseData.memberCreatedAtConverter,
            ascending: true,
          ),
        child: UsersCubitWrapper(
          builder: (context, state) {
            return CustomListView(
              itemCount: state.userHouseDataList.length,
              itemBuilder: (context, index) {
                final userHouseData = state.userHouseDataList[index];
                return CustomText(
                  text: userHouseData.houseName,
                  style: AppTextStyles.primary,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
