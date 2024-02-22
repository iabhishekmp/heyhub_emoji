import 'package:shared_preferences/shared_preferences.dart';

class SharedPref {
  SharedPref._();

  static late final SharedPreferences _i;
  static SharedPreferences get instance => _i;

  static Future<void> init() async {
    _i = await SharedPreferences.getInstance();
  }
}
