import 'package:app_ui/app_ui.dart';
import 'package:roommate_expense_tracker/features/users/widgets/helpers.dart';

class ProfilePicture extends StatelessWidget {
  const ProfilePicture({
    super.key,
    required this.photoUrl,
    required this.id,
    this.aspectX = 1,
    this.aspectY = 1,
    this.width = 65,
  });
  final String? photoUrl;
  final int id;
  final double width;
  final double aspectX;
  final double aspectY;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: imageWidget(
        context: context,
        borderRadius: defaultBorderRadius,
        data: photoUrl ?? 'https://picsum.photos/id/$id/300/300',
        width: width,
        aspectX: aspectX,
        aspectY: aspectY,
      ),
    );
  }
}
