import 'package:app_ui/app_ui.dart';

Widget loadingWidget({
  required BuildContext context,
  required double aspectX,
  required double aspectY,
}) {
  return AspectRatio(
    aspectRatio: aspectX / aspectY,
    child: Container(
      decoration: const BoxDecoration(
        borderRadius: defaultBorderRadius,
      ),
      child: const Center(child: CircularProgressIndicator()),
    ),
  );
}

Widget errorWidget({
  required BuildContext context,
  required double aspectX,
  required double aspectY,
  required double x,
  required BorderRadius borderRadius,
}) {
  return AspectRatio(
    aspectRatio: aspectX / aspectY,
    child: Container(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        color: context.theme.colorScheme.primary,
      ),
      child: Center(
        child: Container(
          width: x,
          height: x,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: DecorationImage(
              image: AssetImage(context.theme.defaultImagePath),
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget imageWidget({
  required BuildContext context,
  required String data,
  required double aspectX,
  required double aspectY,
  required double width,
  required BorderRadius borderRadius,
}) {
  return CachedNetworkImage(
    imageUrl: data,
    placeholder: (context, url) => loadingWidget(
      context: context,
      aspectX: aspectX,
      aspectY: aspectY,
    ),
    errorWidget: (context, url, error) {
      return errorWidget(
        x: width == double.infinity ? 64 : width / 4,
        context: context,
        aspectX: aspectX,
        aspectY: aspectY,
        borderRadius: borderRadius,
      );
    },
    imageBuilder: (context, imageProvider) => AspectRatio(
      aspectRatio: aspectX / aspectY,
      child: Container(
        decoration: BoxDecoration(
          color: context.theme.colorScheme.primary,
          borderRadius: borderRadius,
          image: DecorationImage(
            fit: BoxFit.cover,
            image: imageProvider,
          ),
        ),
      ),
    ),
  );
}
