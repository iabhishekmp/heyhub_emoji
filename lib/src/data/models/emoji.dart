import 'dart:convert';

import 'package:flutter/foundation.dart';

@immutable
class HHEmoji {
  final String id;
  final String unicode;
  final String emoji;
  final String description;

  const HHEmoji({
    required this.id,
    required this.unicode,
    required this.emoji,
    required this.description,
  });

  factory HHEmoji.fromMap(Map<String, dynamic> map) {
    return HHEmoji(
      id: map['id'] as String,
      unicode: map['unicode'] as String,
      emoji: map['emoji'] as String,
      description: map['description'] as String,
    );
  }

  factory HHEmoji.fromJson(String source) =>
      HHEmoji.fromMap(json.decode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'unicode': unicode,
      'emoji': emoji,
      'description': description,
    };
  }

  String toJson() => json.encode(toMap());

  HHEmoji copyWith({
    String? id,
    String? unicode,
    String? emoji,
    String? description,
  }) {
    return HHEmoji(
      id: id ?? this.id,
      unicode: unicode ?? this.unicode,
      emoji: emoji ?? this.emoji,
      description: description ?? this.description,
    );
  }

  @override
  String toString() {
    return 'HHEmoji(id: $id, unicode: $unicode, emoji: $emoji, description: $description)';
  }

  @override
  bool operator ==(covariant HHEmoji other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.unicode == unicode &&
        other.emoji == emoji &&
        other.description == description;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        unicode.hashCode ^
        emoji.hashCode ^
        description.hashCode;
  }
}
