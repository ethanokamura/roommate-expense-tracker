import 'package:app_ui/app_ui.dart';
import 'package:app_core/app_core.dart';
import 'package:roommate_expense_tracker/features/users/cubit/users_cubit.dart';
import 'package:roommate_expense_tracker/features/users/widgets/user_cubit_wrapper.dart';
import 'package:users_repository/users_repository.dart';
import 'package:roommate_expense_tracker/features/users/widgets/user_house_card.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({required this.houseId, required this.userId, super.key});
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
          if (state.isLoading) {
            return Center(
                child: CircularProgressIndicator(
              constraints: const BoxConstraints(
                  minHeight: 100, minWidth: 100, maxHeight: 100, maxWidth: 100),
              color: context.theme.accentColor,
            ));
          } else {
            final houseMemberUserInfo = state.houseMemberUserInfoList
                .firstWhere((m) => m.userId == userId,
                    orElse: () => HouseMembersUserInfo(userId: userId));
            final houseMember = state.houseMembersList.firstWhere(
                (m) => m.userId == userId,
                orElse: () => const HouseMembers());
            String? paymentMethod = houseMemberUserInfo.paymentMethod ?? '';
            String? paymentLink = houseMemberUserInfo.paymentLink ?? '';
            String nickname = houseMember.nickname;
            return NestedPageBuilder(
              title: "User Dashboard",
              sectionsData: {
                'Your Info': [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultContainer(
                        child: Row(
                          children: [
                            const CustomText(
                              text: "Nickname: ",
                              style: AppTextStyles.primary,
                            ),
                            Expanded(
                              child: CustomText(
                                text: nickname,
                                style: AppTextStyles.primary,
                                color: context.theme.accentColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                try {
                                  final updated = await _editUserInfoDialog(
                                    context: context,
                                    key: "Nickname",
                                    value: nickname,
                                  );
                                  if (updated != null) {
                                    HouseMembers newHouseMembersData =
                                        houseMember.copyWith(
                                      nickname: updated["Nickname"] ?? '',
                                    );
                                    await usersCubit.updateHouseMembers(
                                      houseMemberId:
                                          houseMember.houseMemberId ?? '',
                                      newHouseMembersData: newHouseMembersData,
                                      token: token,
                                    );
                                    await usersCubit.fetchAllHouseData(
                                        houseId: houseId,
                                        token: token,
                                        userId: userId);
                                  }
                                } catch (e) {
                                  debugPrint(
                                      'Failure editing $key ${e.toString()}');
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(1), // Small padding
                                child: Icon(
                                  Icons.edit,
                                  size: 12,
                                  color: CustomColors.lightPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DefaultContainer(
                        child: Row(
                          children: [
                            const CustomText(
                              text: "Payment Method: ",
                              style: AppTextStyles.primary,
                            ),
                            Expanded(
                              child: CustomText(
                                text: (paymentMethod == '')
                                    ? "NOT SET"
                                    : paymentMethod,
                                style: AppTextStyles.primary,
                                color: (paymentMethod != '')
                                    ? context.theme.accentColor
                                    : context.theme.errorColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                try {
                                  final updated = await _editUserInfoDialog(
                                    context: context,
                                    key: "Payment Method",
                                    value: paymentMethod,
                                  );
                                  if (updated != null) {
                                    Users newUsersData = state.users.copyWith(
                                        paymentMethod:
                                            updated["Payment Method"]);
                                    await usersCubit.updateUsers(
                                      userId: userId,
                                      newUsersData: newUsersData,
                                      token: token,
                                    );
                                    await usersCubit.fetchAllHouseData(
                                        houseId: houseId,
                                        token: token,
                                        userId: userId);
                                  }
                                } catch (e) {
                                  debugPrint(
                                      'Failure editing $key ${e.toString()}');
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(1), // Small padding
                                child: Icon(
                                  Icons.edit,
                                  size: 12,
                                  color: CustomColors.lightPrimary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      DefaultContainer(
                        child: Row(
                          children: [
                            const CustomText(
                              text: "Payment Info: ",
                              style: AppTextStyles.primary,
                            ),
                            Expanded(
                              child: CustomText(
                                text: (paymentLink == "")
                                    ? "NOT SET"
                                    : paymentLink,
                                style: AppTextStyles.primary,
                                color: (paymentLink != "")
                                    ? context.theme.accentColor
                                    : context.theme.errorColor,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                try {
                                  final updated = await _editUserInfoDialog(
                                    context: context,
                                    key: "Payment Info",
                                    value: paymentLink,
                                  );
                                  if (updated != null) {
                                    Users newUsersData = state.users.copyWith(
                                        paymentLink: updated["Payment Info"]);
                                    await usersCubit.updateUsers(
                                      userId: userId,
                                      newUsersData: newUsersData,
                                      token: token,
                                    );
                                    await usersCubit.fetchAllHouseData(
                                        houseId: houseId,
                                        token: token,
                                        userId: userId);
                                  }
                                } catch (e) {
                                  debugPrint(
                                      'Failure editing $key ${e.toString()}');
                                }
                              },
                              child: const Padding(
                                padding: EdgeInsets.all(1), // Small padding
                                child: Icon(
                                  Icons.edit,
                                  size: 12,
                                  color: CustomColors.lightPrimary,
                                ),
                              ),
                            ),
                          ],
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
                    text: "Houses You're In",
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
                      text: 'Most Recently Joined',
                      onSelect: () async {},
                    ),
                  ])
                ],
              ),
              itemBuilder: (context, index) => UsersHouseCard(
                userHouse: state.userHouseDataList[index],
              ),
              itemCount: state.userHouseDataList.length,
              isLoading: state.isLoading,
              emptyMessage: 'You are not a member of any houses yet!',
            );
          }
        },
      ),
    );
  }

  Future<Map<String, String>?> _editUserInfoDialog({
    required BuildContext context,
    required String key,
    required String value,
  }) {
    final valueController = TextEditingController(text: value);
    final formKey = GlobalKey<FormState>();

    return showDialog<Map<String, String>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit $key'),
          content: DefaultContainer(
            horizontal: 0,
            vertical: 0,
            child: Form(
              key: formKey,
              child: TextFormField(
                controller: valueController,
                maxLength: 99,
                validator: (value) {
                  if (key == "Nickname" &&
                      (value == null || value.trim().isEmpty)) {
                    return 'Please enter a value';
                  }
                  return null;
                },
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const CustomText(
                text: 'Cancel',
                style: AppTextStyles.button,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  Navigator.of(context).pop({
                    key: valueController.text,
                  });
                }
              },
              child: const CustomText(
                text: 'Save',
                style: AppTextStyles.button,
              ),
            ),
          ],
        );
      },
    );
  }
}
