import 'package:app_ui/app_ui.dart';
import 'package:app_core/app_core.dart';
import 'package:users_repository/users_repository.dart';
import 'package:roommate_expense_tracker/app/cubit/app_cubit.dart';

class UsersHouseCard extends StatelessWidget {
  const UsersHouseCard({
    required this.userHouse,
    super.key,
  });

  final UserHouseData userHouse;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        context.showSnackBar('Selected to ${userHouse.houseName}');
        await context.read<AppCubit>().selectedHouse(
              houseId: userHouse.houseId,
              memberId: userHouse.houseMemberId,
            );
      },
      child: DefaultContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomText(
              text: userHouse.houseName,
              style: AppTextStyles.primary,
            ),
            CustomText(
              text: userHouse.memberNickName,
              style: AppTextStyles.secondary,
            ),
            CustomText(
              text: userHouse.isAdmin ? "Owner" : "Member",
              style: AppTextStyles.secondary,
            ),
            CustomText(
              text:
                  'Joined on ${DateFormatter.formatTimestamp(userHouse.memberCreatedAt!)}',
              style: AppTextStyles.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
