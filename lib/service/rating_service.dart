import 'package:shared_preferences/shared_preferences.dart';

class RatingService {
  static const String _launchCountKey = 'launch_count';
  static const String _ratedKey = 'has_rated';

  Future<bool> shouldShowRating() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool(_ratedKey) == true) {
      return false;
    }

    final launchCount = prefs.getInt(_launchCountKey) ?? 0;
    final newCount = launchCount + 1;
    await prefs.setInt(_launchCountKey, newCount);

    if (newCount == 3) {
      await prefs.setBool(_ratedKey, true);
      return true;
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
    // Intentionally empty, as the 3rd launch flag is already handled
  }
}
