import 'package:app_ui/app_ui.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    required this.photoUrl,
    required this.id,
  });
  final String? photoUrl;
  final int id;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: 30, // size of the avatar
      backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
          ? NetworkImage(photoUrl!)
          : NetworkImage('https://picsum.photos/id/$id/300/300'),
      backgroundColor: context.theme.backgroundColor,
    );
  }
}
