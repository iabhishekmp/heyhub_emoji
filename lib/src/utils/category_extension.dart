import '../data/models/emoji.dart';
import '../data/models/emoji_category.dart';

extension CategoryExtension on HHEmojiCategory {
  String get icon {
    return subcategories.first.emojis.first.emoji;
  }

  List<HHEmoji> get allEmojis {
    final result = <HHEmoji>[];
    for (final sc in subcategories) {
      result.addAll(sc.emojis);
    }
    return result;
  }
}

extension EmojiExtension on String {
  String get parse {
    return replaceAll('U+', r'\u');
  }
}

extension AllEmojiExtension on List<HHEmojiCategory> {
  List<HHEmoji> get allEmojis {
    final result = <HHEmoji>[];
    for (final category in this) {
      for (final sc in category.subcategories) {
        result.addAll(sc.emojis);
      }
    }

    return result;
  }
}
