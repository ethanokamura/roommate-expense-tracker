//import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:app_core/app_core.dart';
// import 'package:houses_repository/houses_repository.dart';
import 'package:roommate_expense_tracker/features/users/cubit/users_cubit.dart';
import 'package:roommate_expense_tracker/features/users/widgets/user_cubit_wrapper.dart';
import 'package:users_repository/users_repository.dart';
import 'package:flutter/services.dart';
import 'package:roommate_expense_tracker/features/houses/widgets/roommate_card.dart';
import 'package:roommate_expense_tracker/features/users/widgets/profile_picture.dart';

class HouseDashboard extends StatelessWidget {
  const HouseDashboard({required this.houseId, super.key});
  final String houseId;
  final String houseName = "PLACEHOLDER";
  final String inviteCode = "PLACEHOLDER";

  @override
  Widget build(BuildContext context) {
    final userRepository = context.read<UsersRepository>();
    return BlocProvider(
      create: (context) => UsersCubit(
        usersRepository: userRepository,
      )..fetchAllHouseMembersWithHouseId(
          houseId: houseId,
          token: userRepository.idToken ?? '',
          orderBy: "nickname",
          ascending: false,
        ),
      child: UsersCubitWrapper(
        builder: (context, state) {
          return NestedPageBuilder(
            title: "House Dashboard",
            sectionsData: {
              'House Info': [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: DefaultContainer(
                        child: Column(
                          children: [
                            const CustomText(
                              text: 'House Name',
                              style: AppTextStyles.primary,
                            ),
                            CustomText(
                              text: houseName,
                              style: AppTextStyles.primary,
                              color: context.theme.subtextColor,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const HorizontalSpacer(),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: inviteCode));
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text("Copied To Dashboard")));
                        },
                        child: DefaultContainer(
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  children: [
                                    const CustomText(
                                      text: 'Invite Code',
                                      style: AppTextStyles.primary,
                                      maxLines: 1,
                                    ),
                                    CustomText(
                                      text: inviteCode,
                                      style: AppTextStyles.primary,
                                      color: context.theme.subtextColor,
                                      maxLines: 1,
                                    ),
                                  ],
                                ),
                              ),
                              const HorizontalSpacer(),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            },
            filter: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomText(
                  text: 'Roommate List',
                  style: AppTextStyles.title,
                  color: context.theme.accentColor,
                ),
                DropDown(dropDownItems: [
                  DropDownItem(
                    icon: Icons.sort_by_alpha,
                    text: 'Alphabetical Order',
                    onSelect: () async {},
                  ),
                  DropDownItem(
                    icon: AppIcons.calendar,
                    text: 'Most Recently Added',
                    onSelect: () async {},
                  ),
                ])
              ],
            ),
            itemCount: state.houseMembersList.length,
            itemBuilder: (context, index) {
              // get list of roommates
              return RoommateCard(
                profilePicture: const ProfilePicture(photoUrl: null),
                name: state.houseMembersList[index].nickname,
                paymentMethod: "Preffered Payment Method: Zelle",
                paymentMethodId: "831-xxx-xxxx",
              );
            },
            isLoading: state.isLoading,
            emptyMessage: 'No roommates in house',
          );
        },
      ),
    );
  }
}
