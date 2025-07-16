import 'package:app_ui/app_ui.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({super.key, required this.photoUrl});
  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30, // size of the avatar
      backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
          ? NetworkImage(photoUrl!)
          : const AssetImage('assets/logos/ret_logo_no_bg.png')
              as ImageProvider,
      backgroundColor: context.theme.backgroundColor,
    );
  }
}
