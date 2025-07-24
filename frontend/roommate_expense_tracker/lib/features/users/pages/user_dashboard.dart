import 'package:app_ui/app_ui.dart';
import 'package:app_core/app_core.dart';
import 'package:roommate_expense_tracker/app/cubit/app_cubit.dart';
import 'package:roommate_expense_tracker/features/houses/widgets/roommate_card.dart';
import 'package:roommate_expense_tracker/features/users/cubit/users_cubit.dart';
import 'package:roommate_expense_tracker/features/users/widgets/profile_picture.dart';
import 'package:roommate_expense_tracker/features/users/widgets/user_cubit_wrapper.dart';
import 'package:roommate_expense_tracker/theme/theme_button.dart';
import 'package:users_repository/users_repository.dart';
import 'package:roommate_expense_tracker/features/users/widgets/user_house_card.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});
  @override
  Widget build(BuildContext context) {
    final userRepository = context.read<UsersRepository>();
    final token = userRepository.idToken ?? '';
    final usersCubit = UsersCubit(usersRepository: userRepository);
    return BlocProvider<UsersCubit>(
      create: (context) => usersCubit
        ..fetchAllHouseData(
          houseId: userRepository.getHouseId,
          userId: userRepository.users.userId!,
          token: token,
        ),
      child: UsersCubitWrapper(
        builder: (context, state) {
          final houseMemberUserInfo = state.houseMemberUserInfoList.firstWhere(
              (m) => m.userId == userRepository.users.userId!,
              orElse: () =>
                  HouseMembersUserInfo(userId: userRepository.users.userId!));
          final houseMember = state.houseMembersList.firstWhere(
              (m) => m.userId == userRepository.users.userId!,
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
                    RoommateCard(
                      key: ObjectKey(userRepository.users.userId!),
                      isLoading: state.isLoading,
                      profilePicture: ProfilePicture(
                        photoUrl: houseMemberUserInfo.photoUrl,
                        id: 500,
                      ),
                      name: nickname,
                      paymentMethod: paymentMethod,
                      paymentLink: paymentLink,
                    ),
                    const VerticalSpacer(),
                    DefaultContainer(
                      child: Row(
                        children: [
                          const CustomText(
                            text: "Nickname: ",
                            style: AppTextStyles.primary,
                          ),
                          Expanded(
                            child: CustomText(
                              text: state.isLoading ? '' : nickname,
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
                                  if (!context.mounted) return;
                                  await usersCubit.fetchAllHouseData(
                                    houseId: userRepository.getHouseId,
                                    userId: userRepository.users.userId!,
                                    token: token,
                                  );
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
                                size: 16,
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
                              text: state.isLoading
                                  ? ''
                                  : (paymentMethod == '')
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
                                    paymentMethod: updated["Payment Method"],
                                    paymentLink: paymentLink,
                                  );
                                  await usersCubit.updateUsers(
                                    userId: userRepository.users.userId!,
                                    newUsersData: newUsersData,
                                    token: token,
                                  );
                                  if (!context.mounted) return;
                                  await usersCubit.fetchAllHouseData(
                                    houseId: userRepository.getHouseId,
                                    userId: userRepository.users.userId!,
                                    token: token,
                                  );
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
                                size: 16,
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
                              text: state.isLoading
                                  ? ''
                                  : (paymentLink == "")
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
                                    paymentLink: updated["Payment Info"],
                                    paymentMethod: paymentMethod,
                                  );
                                  await usersCubit.updateUsers(
                                    userId: userRepository.users.userId!,
                                    newUsersData: newUsersData,
                                    token: token,
                                  );
                                  if (!context.mounted) return;
                                  await usersCubit.fetchAllHouseData(
                                    houseId: userRepository.getHouseId,
                                    userId: userRepository.users.userId!,
                                    token: token,
                                  );
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
                                size: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                CustomButton(
                  onTap: () async => context.read<AppCubit>().signOut(),
                  text: 'Sign Out',
                  icon: AppIcons.logOut,
                ),
                const ThemeButton(),
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
                cursorColor: context.theme.subtextColor,
                maxLength: 99,
                decoration: defaultTextFormFieldDecoration(
                  context: context,
                  label: key,
                ),
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
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    onTap: () => Navigator.of(context).pop(),
                    text: 'Cancel',
                    color: context.theme.backgroundColor,
                  ),
                ),
                const HorizontalSpacer(),
                Expanded(
                  child: CustomButton(
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        Navigator.of(context).pop({
                          key: valueController.text,
                        });
                      }
                    },
                    text: 'Save',
                    color: context.theme.accentColor,
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
