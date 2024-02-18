import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'emoji.dart';

@immutable
class HHEmojiSubcategory {
  final String name;
  final List<HHEmoji> emojis;

  const HHEmojiSubcategory({
    required this.name,
    required this.emojis,
  });

  HHEmojiSubcategory copyWith({
    String? name,
    List<HHEmoji>? emojis,
  }) {
    return HHEmojiSubcategory(
      name: name ?? this.name,
      emojis: emojis ?? this.emojis,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'emojis': emojis.map((x) => x.toMap()).toList(),
    };
  }

  factory HHEmojiSubcategory.fromMap(Map<String, dynamic> map) {
    return HHEmojiSubcategory(
      name: map['name'] as String,
      emojis: List<HHEmoji>.from(
        (map['emojis'] as List<int>).map<HHEmoji>(
          (x) => HHEmoji.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }

  String toJson() => json.encode(toMap());

  factory HHEmojiSubcategory.fromJson(String source) =>
      HHEmojiSubcategory.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'HHEmojiSubcategory(name: $name, emojis: $emojis)';

  @override
  bool operator ==(covariant HHEmojiSubcategory other) {
    if (identical(this, other)) return true;

    return other.name == name && listEquals(other.emojis, emojis);
  }

  @override
  int get hashCode => name.hashCode ^ emojis.hashCode;
}
