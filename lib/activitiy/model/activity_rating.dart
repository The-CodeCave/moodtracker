enum ActivityRating {
  none,
  bad,
  neutral,
  good;

  static ActivityRating fromString(String s) {
    switch (s) {
      case 'bad':
        return ActivityRating.bad;
      case 'neutral':
        return ActivityRating.neutral;
      case 'good':
        return ActivityRating.good;
      default:
        return ActivityRating.none;
    }
  }

  int toNumber() {
    switch (this) {
      case ActivityRating.bad:
        return 0;
      case ActivityRating.neutral:
        return 1;
      case ActivityRating.good:
        return 2;
      default:
        return 0;
    }
  }
}
