import 'dart:convert';

import '../../utils/app_dio.dart';
import '../../utils/endpoints.dart';
import '../models/emoji.dart';
import '../models/emoji_category.dart';
import '../models/emoji_subcategory.dart';

part 'github_infra.dart';

sealed class Infrastructure {
  Future<List<HHEmojiCategory>> fetch();
}
