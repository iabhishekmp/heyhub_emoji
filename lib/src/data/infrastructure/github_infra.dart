part of 'infrastructure.dart';

class GithubInfra extends Infrastructure {
  @override
  Future<List<HHEmojiCategory>> fetch() async {
    final res = await AppDio.instance.get<dynamic>(Endpoints.github);
    if (res.statusCode case 200 || 201) {
      final data = jsonDecode(res.data as String) as List<List<String>>;
    }
    return [];
  }
}
