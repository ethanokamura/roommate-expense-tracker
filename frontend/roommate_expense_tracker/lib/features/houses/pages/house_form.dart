import 'package:app_ui/app_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final token = context.read<UsersRepository>().credentials.credential?.accessToken ?? '';
    final userId = context.read<UsersRepository>().users.userId;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Create/Join House'),
        backgroundColor: context.theme.backgroundColor,
        foregroundColor: context.theme.surfaceColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CustomText(
              text: 'Create a House',
              style: AppTextStyles.title,
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
                  token: token,
                );

                if (context.mounted) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const HouseSelectionPage()),
                  );
                }
              },
              child: const Text("Create House"),
            ),
            const Divider(height: 40),
            const CustomText(
              text: 'Join a House',
              style: AppTextStyles.title,
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
                  await context.read<HousesCubit>().fetchHousesWithHouseId(
                    houseId: code,
                    token: token,
                  );
                  final houseState = context.read<HousesCubit>().state;

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
