import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:roommate_expense_tracker/features/users/cubit/users_cubit.dart';
import 'package:users_repository/users_repository.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  bool isEditingNickname = false;
  late TextEditingController nicknameController;

  @override
  void initState() {
    super.initState();
    nicknameController = TextEditingController();
  }

  @override
  void dispose() {
    nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userRepository = context.read<UsersRepository>();
    
    return BlocProvider(
      create: (context) => UsersCubit(
        usersRepository: context.read<UsersRepository>(),
      )..fetchUsersHouseData(
          userId: userRepository.users.userId!,
          token: userRepository.idToken ?? '',
          forceRefresh: true,
        ),
      child: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          // Get current user nickname from repository or state
          final currentNickname = userRepository.users.nickname ?? 'User';
          
          // Update controller when nickname changes (only once)
          if (nicknameController.text != currentNickname && !isEditingNickname) {
            nicknameController.text = currentNickname;
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Welcome Section
                  _buildWelcomeSection(context, currentNickname, state.userHouseDataList),
                  
                  const VerticalBar(),
                  
                  // Nickname Section
                  _buildNicknameSection(context, currentNickname, userRepository),
                  
                  const VerticalBar(),
                  
                  // Houses Section
                  _buildHousesSection(context, state),
                  
                  const VerticalBar(),
                  
                  // Logout Button
                  _buildLogoutButton(context),
                  
                  const VerticalSpacer(multiple: 6),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, String nickname, List<UserHouseData> userHouses) {
    return DefaultContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: 'Welcome back, $nickname!',
            style: AppTextStyles.appBar,
            color: context.theme.accentColor,
          ),
          const VerticalSpacer(),
          CustomText(
            text: 'You\'re a part of ${userHouses.length} house${userHouses.length == 1 ? '' : 's'}',
            style: AppTextStyles.secondary,
            color: context.theme.subtextColor,
          ),
        ],
      ),
    );
  }

  Widget _buildNicknameSection(BuildContext context, String currentNickname, UsersRepository userRepository) {
    return DefaultContainer(
      child: Row(
        children: [
          CustomText(
            text: 'Nickname: ',
            style: AppTextStyles.primary,
          ),
          Expanded(
            child: isEditingNickname
                ? customTextFormField(
                    context: context,
                    label: '',
                    controller: nicknameController,
                    onBackground: false,
                  )
                : CustomText(
                    text: currentNickname,
                    style: AppTextStyles.primary,
                  ),
          ),
          const HorizontalSpacer(),
          GestureDetector(
            onTap: () {
              if (isEditingNickname) {
                // Save nickname
                _saveNickname(nicknameController.text, userRepository);
                setState(() {
                  isEditingNickname = false;
                });
              } else {
                // Start editing
                setState(() {
                  isEditingNickname = true;
                });
              }
            },
            child: Icon(
              isEditingNickname ? Icons.check : Icons.edit,
              color: context.theme.accentColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHousesSection(BuildContext context, UsersState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Houses:',
          style: AppTextStyles.primary,
        ),
        const VerticalSpacer(),
        
        // Show loading state
        if (state.isLoading)
          const Center(child: CircularProgressIndicator())
        
        // Show empty state
        else if (state.userHouseDataList.isEmpty)
          DefaultContainer(
            child: CustomText(
              text: 'You are not a member of any houses yet!',
              style: AppTextStyles.secondary,
              color: context.theme.subtextColor,
            ),
          )
        
        // Show house cards
        else
          ...state.userHouseDataList.map((userHouse) => 
            _buildHouseCard(context, userHouse)).toList(),
      ],
    );
  }

  Widget _buildHouseCard(BuildContext context, UserHouseData userHouse) {
    return Container(
      margin: const EdgeInsets.only(bottom: defaultPadding),
      child: DefaultContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: CustomText(
                    text: userHouse.houseName,
                    style: AppTextStyles.title,
                  ),
                ),
                if (!userHouse.isAdmin)
                  GestureDetector(
                    onTap: () => _leaveHouse(userHouse.houseMemberId),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red),
                        borderRadius: defaultBorderRadius,
                      ),
                      child: const CustomText(
                        text: 'leave button',
                        style: AppTextStyles.secondary,
                        color: Colors.red,
                      ),
                    ),
                  )
                else
                  CustomTag(
                    text: 'Head',
                    color: context.theme.accentColor,
                  ),
              ],
            ),
            const VerticalSpacer(),
            Row(
              children: [
                Icon(
                  AppIcons.user,
                  size: 16,
                  color: context.theme.subtextColor,
                ),
                const HorizontalSpacer(multiple: 0.5),
                CustomText(
                  text: 'Joined ${DateFormatter.formatTimestamp(userHouse.memberCreatedAt!)}',
                  style: AppTextStyles.secondary,
                  color: context.theme.subtextColor,
                ),
              ],
            ),
            const VerticalSpacer(),
            CustomButton(
              text: 'View House Dashboard',
              onTap: () => _navigateToHouseDashboard(userHouse.houseId, userHouse.houseMemberId),
              color: context.theme.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: CustomButton(
        text: 'Logout',
        onTap: _logout,
        color: context.theme.primaryColor,
      ),
    );
  }

  // Updated methods to work with real data
  void _saveNickname(String newNickname, UsersRepository userRepository) async {
    try {
      // Update through your repository/API
      await userRepository.updateUserNickname(newNickname);
      // The repository should update its internal state
    } catch (e) {
      // Handle error - maybe show a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update nickname: $e')),
      );
    }
  }

  void _leaveHouse(String houseMemberId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.theme.backgroundColor,
        title: CustomText(
          text: 'Leave House',
          style: AppTextStyles.title,
        ),
        content: const CustomText(
          text: 'Are you sure you want to leave this house?',
          style: AppTextStyles.primary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CustomText(
              text: 'Cancel',
              style: AppTextStyles.secondary,
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                // Call your real API to leave house
                final userRepository = context.read<UsersRepository>();
                await userRepository.leaveHouse(houseMemberId);
                
                // Refresh the data
                context.read<UsersCubit>().fetchUsersHouseData(
                  userId: userRepository.users.userId!,
                  token: userRepository.idToken ?? '',
                  forceRefresh: true,
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Failed to leave house: $e')),
                );
              }
            },
            child: const CustomText(
              text: 'Leave',
              style: AppTextStyles.primary,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToHouseDashboard(String houseId, String memberId) {
    // Use the same pattern as HouseSelectionPage
    context.read<AppCubit>().selectedHouse(
      houseId: houseId,
      memberId: memberId,
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.theme.backgroundColor,
        title: CustomText(
          text: 'Logout',
          style: AppTextStyles.title,
        ),
        content: const CustomText(
          text: 'Are you sure you want to logout?',
          style: AppTextStyles.primary,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const CustomText(
              text: 'Cancel',
              style: AppTextStyles.secondary,
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                // Clear auth and navigate to login
                final userRepository = context.read<UsersRepository>();
                await userRepository.logout();
                
                // Navigate to login screen
                context.read<AppCubit>().logout();
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Logout failed: $e')),
                );
              }
            },
            child: const CustomText(
              text: 'Logout',
              style: AppTextStyles.primary,
            ),
          ),
        ],
      ),
    );
  }
}