import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';

enum ThemeState { light, dark }

/// Manages the state and logic for theme-related operations.
class ThemeCubit extends Cubit<ThemeState> {
  /// Creates a new instance of [ThemeCubit].
  /// Loads user preferences on initialization
  ThemeCubit() : super(ThemeState.light);

  /// Public getter for the current theme
  ThemeData get themeData => theme;
}
