import 'package:api_client/api_client.dart';
import 'package:app_ui/app_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:houses_repository/houses_repository.dart';
import 'package:roommate_expense_tracker/features/users/cubit/users_cubit.dart';
import 'package:roommate_expense_tracker/features/users/pages/house_selection.dart';
import 'package:users_repository/users_repository.dart';
import 'package:roommate_expense_tracker/features/houses/cubit/houses_cubit.dart';

class HouseFormPage extends StatelessWidget {
  const HouseFormPage({super.key});

  @override
  Widget build(BuildContext context) {
    final houseNameController = TextEditingController();
    final inviteCodeController = TextEditingController();
    final token = context.read<UsersRepository>().idToken ?? '';
    final userId = context.read<UsersRepository>().users.userId ??'';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create/Join House'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          color: context.theme.subtextColor,
          onPressed: () => Navigator.pop(context, true),
        ),
        backgroundColor: context.theme.surfaceColor,
        foregroundColor: context.theme.textColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomText(
              text: 'Create a House',
              style: AppTextStyles.title,
              color: context.theme.accentColor,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintStyle: TextStyle(color: context.theme.subtextColor),
                hintText: 'Enter House Name'),
              controller: houseNameController,
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () async {
                final houseName = houseNameController.text.trim();

                if (houseName.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter a house name.')),
                  );
                  return;
                }

                await context.read<HousesCubit>().createHouses(
                  name: houseName,
                  userId: userId,
                  token: token,
                );
                final houseState = context.read<HousesCubit>().state;
                
                await context.read<UsersCubit>().createHouseMembers(
                  userId: userId, 
                  houseId: houseState.houses.houseId??'', 
                  isAdmin: true.toString(), 
                  isActive: true.toString(), 
                  token: token,
                );
                final userState = context.read<UsersCubit>().state;

                await context.read<UsersCubit>().updateHouseMembers(
                  houseMemberId: userState.houseMembers.houseMemberId ?? '', 
                  newHouseMembersData: userState.houseMembers, 
                  token: token,
                );

                // await context.read<HousesCubit>().updateHouses(
                //   houseId: houseId,
                //   newHousesData: houseState.houses, 
                //   token: token,
                // );

                if (context.mounted) {
                  Navigator.pop(
                    context,
                    true,
                  );
                }
              },
              child: const Text("Create House"),
            ),
            const Divider(height: 40),
            CustomText(
              text: 'Join a House',
              style: AppTextStyles.title,
              color: context.theme.accentColor,
            ),
            const SizedBox(height: 12),
            TextField(
              decoration: InputDecoration(
                hintStyle: TextStyle(color: context.theme.subtextColor),
                hintText: 'Enter Invite Code'),
              controller: inviteCodeController,
            ),
            const SizedBox(height: 8),
            FilledButton(
              onPressed: () async {
                final code = inviteCodeController.text.trim();
                if (code.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please enter an invite code.')),
                  );
                  return;
                }

                try {
                  await context.read<UsersCubit>().createHouseMembers(
                    userId: userId!,
                    houseId: code,
                    isAdmin: false.toString(),
                    isActive: true.toString(),
                    token: token,
                  );                
                  final userState = context.read<UsersCubit>().state;

                  await context.read<UsersCubit>().updateHouseMembers(
                    houseMemberId: userState.houseMembers.houseMemberId!,
                    newHouseMembersData: userState.houseMembers,
                    token: token,
                  );

                  if (context.mounted) {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const HouseSelectionPage()),
                    );
                  }
                } catch (e) {
                  debugPrint('Error joining house: $e');
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Failed to join house.')),
                  );
                }
              },
              child: const Text("Join House"),
            ),
          ],
        ),
      ),
    );
  }
}
