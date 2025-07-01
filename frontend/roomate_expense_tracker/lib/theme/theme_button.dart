import 'package:app_ui/app_ui.dart';
import 'package:app_core/app_core.dart';
import 'theme_cubit.dart';

class ThemeButton extends StatefulWidget {
  const ThemeButton({super.key});

  @override
  State<ThemeButton> createState() => ThemeButtonState();
}

class ThemeButtonState extends State<ThemeButton> {
  late bool isDarkMode;
  @override
  void initState() {
    isDarkMode = context.read<ThemeCubit>().isDarkMode;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppBarButton(
      icon: isDarkMode ? AppIcons.darkMode : AppIcons.lightMode,
      onTap: () async {
        await context.read<ThemeCubit>().toggleTheme();
        setState(() {
          isDarkMode = context.read<ThemeCubit>().isDarkMode;
        });
      },
    );
  }
}
