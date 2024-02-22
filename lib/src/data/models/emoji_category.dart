import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'emoji_subcategory.dart';

@immutable
class HHEmojiCategory {
  final String name;
  final List<HHEmojiSubcategory> subcategories;

  const HHEmojiCategory({
    required this.name,
    required this.subcategories,
  });

  HHEmojiCategory copyWith({
    String? name,
    List<HHEmojiSubcategory>? subcategories,
  }) {
    return HHEmojiCategory(
      name: name ?? this.name,
      subcategories: subcategories ?? this.subcategories,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'subcategories': subcategories.map((x) => x.toMap()).toList(),
    };
  }

  factory HHEmojiCategory.fromMap(Map<String, dynamic> map) {
    return HHEmojiCategory(
      name: map['name'] as String,
      subcategories: List<HHEmojiSubcategory>.from(
        (map['subcategories'] as List).map<HHEmojiSubcategory>(
          (x) => HHEmojiSubcategory.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory HHEmojiCategory.fromJson(String source) =>
      HHEmojiCategory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'HHEmojiCategory(name: $name, subcategories: $subcategories)';

  @override
  bool operator ==(covariant HHEmojiCategory other) {
    if (identical(this, other)) return true;

    return other.name == name && listEquals(other.subcategories, subcategories);
  }

  @override
  int get hashCode => name.hashCode ^ subcategories.hashCode;
}
