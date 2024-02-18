import 'dart:convert';

import '../../utils/app_dio.dart';
import '../../utils/endpoints.dart';
import '../models/emoji_category.dart';

part 'github_infra.dart';

sealed class Infrastructure {
  Future<List<HHEmojiCategory>> fetch();
}
