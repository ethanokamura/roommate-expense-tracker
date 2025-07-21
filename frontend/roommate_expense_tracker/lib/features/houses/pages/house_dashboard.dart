//import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:app_core/app_core.dart';
import 'package:roommate_expense_tracker/features/users/cubit/users_cubit.dart';
import 'package:roommate_expense_tracker/features/users/widgets/user_cubit_wrapper.dart';
import 'package:users_repository/users_repository.dart';
import 'package:flutter/services.dart';
import 'package:roommate_expense_tracker/features/houses/widgets/roommate_card.dart';
import 'package:roommate_expense_tracker/features/users/widgets/profile_picture.dart';

class HouseDashboard extends StatelessWidget {
  const HouseDashboard(
      {required this.houseId, required this.userId, super.key});
  final String houseId;
  final String userId;

  @override
  Widget build(BuildContext context) {
    final userRepository = context.read<UsersRepository>();
    final token = userRepository.idToken ?? '';
    final usersCubit = UsersCubit(usersRepository: userRepository);
    usersCubit.fetchAllHouseData(
      houseId: houseId,
      userId: userId,
      token: token,
    );
    return BlocProvider.value(
      value: usersCubit,
      child: UsersCubitWrapper(
        builder: (context, state) {
          UserHouseData? houseData;
          for (final data in state.userHouseDataList) {
            if (data.houseId == houseId) {
              houseData = data;
              break;
            }
          }
          if (houseData == null) {
            if (state.isLoading) {
              return Center(
                  child: CircularProgressIndicator(
                constraints: const BoxConstraints(
                    minHeight: 100,
                    minWidth: 100,
                    maxHeight: 100,
                    maxWidth: 100),
                color: context.theme.accentColor,
              ));
            } else {
              return Center(
                  child: CustomText(
                text: "ERROR: HOUSE DATA COULDN'T BE LOADED",
                style: AppTextStyles.primary,
                color: context.theme.errorColor,
              ));
            }
          }
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
                              text: houseData.houseName,
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
                          Clipboard.setData(ClipboardData(text: houseId));
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
                                      text: houseId,
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
              final photoUrl = state.houseMemberUserInfoList[index].photoUrl;
              final paymentMethod =
                  state.houseMemberUserInfoList[index].paymentMethod ??
                      'NOT SET';
              final paymentLink =
                  state.houseMemberUserInfoList[index].paymentLink ?? 'NOT SET';
              // get list of roommates
              return RoommateCard(
                profilePicture:
                    ProfilePicture(photoUrl: photoUrl, id: index + 500),
                name: state.houseMembersList[index].nickname,
                paymentMethod: paymentMethod,
                paymentLink: paymentLink,
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
