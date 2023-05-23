// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'activity_category.dart';

class ActivityFilter {
  final ActivityCategory? selectedCategory;
  final String? nameFilter;
  ActivityFilter({
    this.selectedCategory,
    this.nameFilter,
  });

  bool get isActive => nameFilter != null || selectedCategory != null;

  ActivityFilter copyWith({
    ActivityCategory? selectedCategory,
    String? nameFilter,
  }) {
    return ActivityFilter(
      selectedCategory: selectedCategory,
      nameFilter: nameFilter,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'selectedCategory': selectedCategory?.name,
      'nameFilter': nameFilter,
    };
  }

  factory ActivityFilter.fromMap(Map<String, dynamic> map) {
    return ActivityFilter(
      selectedCategory: map['selectedCategory'] != null ? ActivityCategory.fromString(map['selectedCategory']) : null,
      nameFilter: map['nameFilter'] != null ? map['nameFilter'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory ActivityFilter.fromJson(String source) => ActivityFilter.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ActivityFilter(selectedCategory: $selectedCategory, nameFilter: $nameFilter)';

  @override
  bool operator ==(covariant ActivityFilter other) {
    if (identical(this, other)) return true;

    return other.selectedCategory == selectedCategory && other.nameFilter == nameFilter;
  }

  @override
  int get hashCode => selectedCategory.hashCode ^ nameFilter.hashCode;
}
