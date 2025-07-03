import 'package:app_core/app_core.dart';
import 'package:app_ui/app_ui.dart';

enum ThemeState { light, dark }

/// Manages the state and logic for theme-related operations.
class ThemeCubit extends Cubit<ThemeState> {
  /// Creates a new instance of [ThemeCubit].
  /// Loads user preferences on initialization
  ThemeCubit() : super(ThemeState.dark) {
    _loadFromPrefs();
  }

  bool get isDarkMode => state == ThemeState.dark;

  /// Toggles light mode / dark mode
  Future<void> toggleTheme() async {
    final newState =
        state == ThemeState.light ? ThemeState.dark : ThemeState.light;
    emit(newState);
    await _saveToPrefs(newState);
  }

  /// Public getter for the current theme
  ThemeData get themeData {
    return state == ThemeState.light ? lightMode : darkMode;
  }

  /// Retrieves user preferences using the [SharedPreferences] library
  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDark') ?? false;
    emit(isDark ? ThemeState.dark : ThemeState.light);
  }

  /// Saves changes to [SharedPreferences]
  Future<void> _saveToPrefs(ThemeState state) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDark', state == ThemeState.dark);
  }
}
