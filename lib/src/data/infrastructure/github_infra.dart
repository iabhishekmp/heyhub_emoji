part of 'infrastructure.dart';

class GithubInfra extends Infrastructure {
  @override
  Future<List<HHEmojiCategory>> fetch() async {
    //? fetch emojis from github
    final res = await AppDio.instance.get<dynamic>(Endpoints.github);
    if (res.statusCode case 200 || 201) {
      final data = jsonDecode(res.data as String) as List;
      return _parse(data);
    }
    return [];
  }

  List<HHEmojiCategory> _parse(List<dynamic> items) {
    final result = List<HHEmojiCategory>.empty(growable: true);

    //? iterate over the main response list
    for (var i = 0; i < items.length; i++) {
      final list = items[i] as List;

      //? nextLength to differentiate between category & subcategory
      // ['Smileys & Emotion'], --> category
      // ['face-smiling'],   --> subcategory
      final nextLength =
          i == (items.length - 1) ? 0 : (items[i + 1] as List).length;

      // match the pattern with dart 3
      switch (list) {
        //? category
        case [final String name] when nextLength == 1:
          final category = HHEmojiCategory(
            name: name,
            subcategories: List.empty(growable: true),
          );
          result.add(category);

        //? sub-category
        case [final String name] when nextLength != 1:
          final subCategory = HHEmojiSubcategory(
            name: name,
            emojis: List.empty(growable: true),
          );
          result.last.subcategories.add(subCategory);

        //? emoji
        case [
            final String id,
            final String unicode,
            final String emoji,
            final String description
          ]:
          final e = HHEmoji(
            id: id,
            unicode: unicode,
            emoji: emoji,
            description: description,
          );
          result.last.subcategories.last.emojis.add(e);
      }
    }
    return result;
  }
}
