import 'package:shared_preferences/shared_preferences.dart';

class RatingService {
  static const String _firstLaunchKey = 'first_launch';
  static const String _launchCountKey = 'launch_count';
  static const String _lastPromptKey = 'last_prompt';
  static const String _ratedKey = 'has_rated';

  Future<bool> shouldShowRating() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(_ratedKey) == true) {
      return false;
    }

    final firstLaunch = prefs.getString(_firstLaunchKey);
    final launchCount = prefs.getInt(_launchCountKey) ?? 0;
    final lastPrompt = prefs.getString(_lastPromptKey);

    if (firstLaunch == null) {
      final now = DateTime.now().toIso8601String();
      await prefs.setString(_firstLaunchKey, now);
      await prefs.setInt(_launchCountKey, 1);
      return false;
    }

    await prefs.setInt(_launchCountKey, launchCount + 1);

    if (launchCount >= 5) {
      final firstLaunchDate = DateTime.parse(firstLaunch);
      final daysSinceFirstLaunch = DateTime.now()
          .difference(firstLaunchDate)
          .inDays;

      if (daysSinceFirstLaunch >= 3) {
        if (lastPrompt == null) {
          await prefs.setString(
            _lastPromptKey,
            DateTime.now().toIso8601String(),
          );
          return true;
        } else {
          final lastPromptDate = DateTime.parse(lastPrompt);
          final daysSinceLastPrompt = DateTime.now()
              .difference(lastPromptDate)
              .inDays;
          if (daysSinceLastPrompt >= 7) {
            await prefs.setString(
              _lastPromptKey,
              DateTime.now().toIso8601String(),
            );
            return true;
          }
        }
      }
    }

    return false;
  }

  // In rating_service.dart - add this method
  Future<bool> shouldShowRatingForTesting() async {
    final prefs = await SharedPreferences.getInstance();

    // For testing, always return true
    return true;
  }

  Future<void> setRated() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_ratedKey, true);
  }

  Future<void> setLater() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastPromptKey, DateTime.now().toIso8601String());
  }
}
