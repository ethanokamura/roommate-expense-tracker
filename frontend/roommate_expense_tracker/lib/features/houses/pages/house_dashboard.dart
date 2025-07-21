import 'package:app_core/app_core.dart';
import 'package:flutter/services.dart';
import 'package:app_ui/app_ui.dart';
import 'package:houses_repository/houses_repository.dart';
import 'package:users_repository/users_repository.dart';
import 'package:roommate_expense_tracker/features/houses/cubit/houses_cubit.dart';
import 'package:roommate_expense_tracker/features/users/cubit/users_cubit.dart';
import 'roommate_management_page.dart';

class HouseDashboard extends StatelessWidget {
  const HouseDashboard({
    required this.houseId,
    super.key,
  });

  final String houseId;
  
  void _editHouseName(BuildContext context, String currentName) async {
    final controller = TextEditingController(text: currentName);
    final token = context.read<UsersRepository>().idToken ?? '';

    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit House Name'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintStyle: TextStyle(color: context.theme.subtextColor),
              hintText: 'Enter new house name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: context.theme.accentColor,
              ),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, {
                'name': controller.text.trim(),
                'forceRefresh': true,
              }),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: context.theme.accentColor,
              ),
              child: const Text('Save'),
            ),
          ],
        );
      },
    );

    final newName = result?['name']?.toString().trim();
    final shouldRefresh = result?['forceRefresh'] == true;

    if (newName != null && newName.isNotEmpty && newName != currentName) {
      final updatedName = Houses(name: newName);
      await context.read<HousesCubit>().updateHouses(
        houseId: houseId,
        newHousesData: updatedName,
        token: token,
      );

      if (shouldRefresh) {
        final userRepo = context.read<UsersRepository>();
        await context.read<UsersCubit>().fetchUsersHouseData(
          userId: userRepo.users.userId!,
          token: token,
          forceRefresh: true,
        );
      }

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('House name updated')),
        );
      }
    }
  }


  Future<void> _showInviteCode(BuildContext context) async {
    final code = houseId;
    final userId = context.read<UsersRepository>().users.userId!;
    final token = context.read<UsersRepository>().idToken ?? '';

    await context.read<UsersCubit>().fetchHouseMembersWithUserId(
      userId: userId,
      token: token,
    );
    final state = context.read<UsersCubit>().state;
    final houseMember = state.houseMembers;

    // if(houseMember.isAdmin){
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Invite Code'),
        content: GestureDetector(
          onTap: () async {
            await Clipboard.setData(ClipboardData(text: code));
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Copied to clipboard')),
            );
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                code,
                style: AppTextStyles.secondary.copyWith(color: context.theme.accentColor),
              ),
              const SizedBox(height: 8),
              const Text('Tap to copy', style: TextStyle(fontSize: 12)),
            ],
          ),
        ),
      ),
    );
    // }
  }

  @override
  Widget build(BuildContext context) {
    final userRepository = context.read<UsersRepository>();
    final token = context.read<UsersRepository>().idToken ?? '';
    final housesCubit = HousesCubit(housesRepository: context.read<HousesRepository>())
      ..fetchHousesWithHouseId(
        houseId: houseId,
        token: token,
      );

    final usersCubit = UsersCubit(usersRepository: userRepository)
      ..fetchAllHouseMembersWithHouseId(
        houseId: houseId,
        token: token,
        orderBy: Users.createdAtConverter,
        ascending: false,
      );

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => housesCubit),
        BlocProvider(create: (_) => usersCubit),
      ],
      child: BlocBuilder<HousesCubit, HousesState>(
        builder: (context, houseState) {
          final houseName = houseState.houses.name;

          return BlocBuilder<UsersCubit, UsersState>(
            builder: (context, usersState) {
              return NestedPageBuilder(
                title: 'House Dashboard',
                sectionsData: {
                  'House Info': [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CustomText(text: houseName, style: AppTextStyles.title),
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, size: 20),
                              onPressed: () => _editHouseName(context, houseName),
                            ),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, size: 20),
                              onPressed: () => _showInviteCode(context),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const RoommateManagementPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.theme.primaryColor,
                          foregroundColor: context.theme.accentColor,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: const Text("Manage Roommates"),
                      ),
                    ),
                  ],
                  'Members': [
                    {'name': 'A', 'paymentMethod': 'Venmo: 123'},
                    {'name': 'B', 'paymentMethod': 'PayPal: 456'},
                    {'name': 'C', 'paymentMethod': 'Zelle: 789'},
                  ].map((member) {
                    final name = member['name']!;
                    final method = member['paymentMethod']!;

                    return GestureDetector(
                      onTap: () async {
                        await Clipboard.setData(ClipboardData(text: method));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Payment method copied')),
                        );
                      },
                      child: DefaultContainer(
                        child: Row(
                          children: [
                            const Icon(Icons.person),
                            const HorizontalSpacer(),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(text: name, style: AppTextStyles.primary),
                                  CustomText(text: method, style: AppTextStyles.secondary),
                                ],
                              ),
                            ),
                            const Icon(Icons.copy),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                },
                itemCount: 0,
                itemBuilder: (_, __) => const SizedBox(),
                isLoading: houseState.status == HousesStatus.loading ||
                    usersState.status == UsersStatus.loading,
                emptyMessage: '',
              );
            },
          );
        },
      ),
    );
  }
}
