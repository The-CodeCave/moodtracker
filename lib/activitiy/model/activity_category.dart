enum ActivityCategory {
  hobby,
  obligation,
  work;

  static ActivityCategory fromString(String s) {
    switch (s) {
      case 'hobby':
        return ActivityCategory.hobby;
      case 'obligation':
        return ActivityCategory.obligation;
      default:
        return ActivityCategory.work;
    }
  }

  static ActivityCategory fromSegments(Set<String> segments) {
    switch (segments.first) {
      case 'hobby':
        return ActivityCategory.hobby;
      case 'obligation':
        return ActivityCategory.obligation;
      default:
        return ActivityCategory.work;
    }
  }
}

extension ActivityCategoryExtension on ActivityCategory {
  toDisplayName() {
    switch (this) {
      case ActivityCategory.hobby:
        return 'Freizeit';
      case ActivityCategory.obligation:
        return 'Verpflichtung';
      default:
        return 'Arbeit';
    }
  }
}
