import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';
import 'package:houses_repository/houses_repository.dart';
import 'package:users_repository/users_repository.dart';

Future<dynamic> createHousePopup({
  required BuildContext context,
  required Future<void> Function() onCreate,
}) async {
  await showDialog<Map<String, dynamic>>(
    context: context,
    builder: (context) => AlertDialog(
      content: Padding(
        padding: const EdgeInsets.only(top: defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: defaultPadding * 2,
                left: defaultPadding * 2,
                right: defaultPadding * 2,
                bottom: 100,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [CreateHouseForm(onCreate: onCreate)],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class CreateHouseForm extends StatefulWidget {
  const CreateHouseForm({
    required this.onCreate,
    super.key,
  });

  final Future<void> Function() onCreate;
  @override
  State<CreateHouseForm> createState() => _CreateHouseFormState();
}

class _CreateHouseFormState extends State<CreateHouseForm> {
  final TextEditingController controller = TextEditingController();
  String houseName = '';

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final usersRepository = context.read<UsersRepository>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: 'Create A House',
          style: AppTextStyles.appBar,
          color: context.theme.accentColor,
        ),
        const VerticalSpacer(),
        customTextFormField(
          context: context,
          label: 'Enter A House Name',
          controller: controller,
          onBackground: false,
          onChanged: (name) => setState(() {
            if (name.trim().isNotEmpty) {
              houseName = name;
            }
          }),
        ),
        const VerticalSpacer(),
        CustomButton(
          text: 'Create House',
          onTap: houseName.isEmpty
              ? null
              : () async {
                  final newHouse =
                      await context.read<HousesRepository>().createHouses(
                            name: houseName,
                            userId: usersRepository.users.userId!,
                            token: usersRepository.idToken ?? '',
                          );
                  if (!context.mounted) return;
                  await usersRepository.createHouseMembers(
                    userId: usersRepository.users.userId!,
                    houseId: newHouse.houseId!,
                    isAdmin: true,
                    isActive: true,
                    token: usersRepository.idToken ?? '',
                  );
                  if (!context.mounted) return;
                  await widget.onCreate();
                  if (!context.mounted) return;
                  Navigator.pop(context);
                },
        )
      ],
    );
  }
}
