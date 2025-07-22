import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:roommate_expense_tracker/features/users/cubit/users_cubit.dart';
import 'package:users_repository/users_repository.dart';
import 'package:roommate_expense_tracker/features/users/widgets/user_house_card.dart';

class HouseSelectionPage extends StatelessWidget {
  const HouseSelectionPage({super.key});
  static MaterialPage<dynamic> page() =>
      const MaterialPage<void>(child: HouseSelectionPage());
  @override
  Widget build(BuildContext context) {
    final userRepository = context.read<UsersRepository>();
    return DefaultPageView(
      title: 'Select Your House',
      body: BlocProvider(
        create: (context) => UsersCubit(
          usersRepository: context.read<UsersRepository>(),
        )..fetchUsersHouseData(
            userId: userRepository.users.userId!,
            token: userRepository.idToken ?? '',
            forceRefresh: true,
          ),
        child: BlocBuilder<UsersCubit, UsersState>(
          builder: (context, state) {
            return NestedPageBuilder(
              sectionsData: {
                'House Selection': [
                  CustomButton(
                    icon: AppIcons.add,
                    text: 'Add House',
                    onTap: () {
                      // navigate to create a house
                    },
                    color: context.theme.accentColor,
                  ),
                ],
              },
              itemBuilder: (context, index) => UsersHouseCard(
                userHouse: state.userHouseDataList[index],
              ),
              itemCount: state.userHouseDataList.length,
              isLoading: state.isLoading,
              emptyMessage: 'You are not a member of any houses yet!',
            );
          },
        ),
      ),
    );
  }
}
