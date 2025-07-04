import 'package:app_ui/src/extensions.dart';
import 'package:app_ui/src/theme.dart';
import 'package:app_ui/src/constants.dart';
import 'package:app_ui/src/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SkeletonText extends StatelessWidget {
  const SkeletonText({
    super.key,
    this.width,
    this.height = 8.0,
  });

  final double? width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.theme.textColor.withValues(alpha: 0.1),
        borderRadius: defaultBorderRadius / 2,
      ),
    )
        .animate(
          onPlay: (controller) => controller.repeat(),
        )
        .shimmer(
          duration: const Duration(seconds: 1),
          delay: const Duration(milliseconds: 200),
          color: context.theme.surfaceColor.withValues(alpha: 0.5),
        );
  }
}

class SkeletonList extends StatelessWidget {
  const SkeletonList({required this.lines, super.key});
  final int lines;
  @override
  Widget build(BuildContext context) {
    return ClipRect(
      clipper: TopClipper(),
      child: ListView.separated(
        clipBehavior: Clip.none,
        physics: const NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) => const SkeletonCard(lines: 3),
        separatorBuilder: (context, index) => const VerticalSpacer(),
        itemCount: lines,
      ),
    );
  }
}

class SkeletonCard extends StatelessWidget {
  const SkeletonCard({
    required this.lines,
    this.hasTitle = true,
    super.key,
  });
  final int lines;
  final bool hasTitle;

  @override
  Widget build(BuildContext context) {
    return DefaultContainer(child: SkeletonRows(lines: lines));
  }
}

class SkeletonRows extends StatelessWidget {
  const SkeletonRows({
    required this.lines,
    this.hasTitle = true,
    super.key,
  });
  final int lines;
  final bool hasTitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SkeletonText(width: 125.0, height: 10),
          const VerticalSpacer(multiple: 0.5),
          ..._buildSkeletons(lines - 1),
        ],
      ),
    );
  }
}

List<Widget> _buildSkeletons(int lines) {
  List<Widget> skeletonLines = [];
  for (int i = 0; i < lines; i++) {
    skeletonLines.add(const SkeletonText(width: double.infinity));
    if (i < lines - 1) skeletonLines.add(const VerticalSpacer(multiple: 0.5));
  }
  return skeletonLines;
}

// class LoadingPage extends StatelessWidget {
//   const LoadingPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const DefaultPageView(
//       body: NestedWrapper(
//         header: [
//           VerticalSpacer(multiple: 2),
//           SkeletonRows(lines: 5),
//           VerticalSpacer(),
//         ],
//         body: [Expanded(child: SkeletonList(lines: 10))],
//       ),
//     );
//   }
// }

class SkeletonDiagram extends StatelessWidget {
  const SkeletonDiagram({
    required this.height,
    this.width = double.infinity,
    super.key,
  });
  final double height;
  final double width;
  @override
  Widget build(BuildContext context) {
    return DefaultContainer(child: SizedBox(height: height));
  }
}
