//import 'package:app_core/app_core.dart';
import 'dart:math';

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
    return BlocProvider<UsersCubit>(
      create: (context) => UsersCubit(
        usersRepository: userRepository,
      )..fetchAllHouseData(houseId: houseId, userId: userId, token: token),
      child: UsersCubitWrapper(
        builder: (context, state) {
          UserHouseData houseData = state.userHouseDataList.firstWhere(
            (element) => element.houseId == houseId,
            orElse: () => UserHouseData.empty,
          );
          return NestedPageBuilder(
            title: "House Dashboard",
            sectionsData: {
              'House Info': [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: state.isLoading
                          ? const SkeletonCard(lines: 2)
                          : DefaultContainer(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
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
                      child: state.isLoading
                          ? const SkeletonCard(lines: 2)
                          : GestureDetector(
                              onTap: () {
                                Clipboard.setData(ClipboardData(text: houseId));
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content: Text("Copied To Dashboard")));
                              },
                              child: DefaultContainer(
                                child: Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const CustomText(
                                            text: 'Invite Code',
                                            style: AppTextStyles.primary,
                                            maxLines: 1,
                                          ),
                                          const HorizontalSpacer(),
                                          defaultIconStyle(
                                            context,
                                            AppIcons.copy,
                                            context.theme.textColor,
                                          ),
                                        ],
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
                    onSelect: () async {
                      context
                          .read<UsersCubit>()
                          .sortHouseMembersAlphabetically();
                    },
                  ),
                  DropDownItem(
                    icon: AppIcons.calendar,
                    text: 'Most Recently Added',
                    onSelect: () async {
                      context.read<UsersCubit>().sortHouseMembersByRecent();
                    },
                  ),
                ])
              ],
            ),
            itemCount: min(state.houseMembersList.length,
                state.houseMemberUserInfoList.length),
            itemBuilder: (context, index) {
              final photoUrl = state.houseMemberUserInfoList[index].photoUrl;
              final paymentMethod =
                  state.houseMemberUserInfoList[index].paymentMethod ?? "";
              final paymentLink =
                  state.houseMemberUserInfoList[index].paymentLink ?? "";
              // get list of roommates
              return RoommateCard(
                isLoading: state.isLoading,
                key: ObjectKey(state.houseMembersList[index].userId),
                profilePicture:
                    ProfilePicture(photoUrl: photoUrl, id: index + 500),
                name: state.houseMembersList[index].nickname,
                paymentMethod: paymentMethod,
                paymentLink: paymentLink,
              );
            },
            isLoading: state.isLoading,
            loadingWidget: const SkeletonProfileList(lines: 5),
            emptyMessage: 'No roommates in house',
          );
        },
      ),
    );
  }
}
