import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static SharedPreferences? _prefs;

  // call this method from iniState() function of mainApp().
  static Future<SharedPreferences?> init() async {
    _prefs = await SharedPreferences.getInstance();
    return _prefs;
  }

  //Setters
  static Future<bool?> setBool(String key, bool value) async =>
      await _prefs?.setBool(key, value);

  static Future<bool?> setInt(String key, int? value) async =>
      await _prefs?.setInt(key, value!);

  static Future<bool?> setString(String key, String value) async =>
      await _prefs?.setString(key, value);

  //Getters
  static bool? getBool(String key, bool defaultValue) =>
      _prefs?.getBool(key) ?? defaultValue;

  static int? getInt(String key, int defaultValue) =>
      _prefs?.getInt(key) ?? defaultValue;

  static String? getString(String key, String defaultValue) =>
      _prefs?.getString(key) ?? defaultValue;

  //Clear prefs
  static Future<bool?> clear() async => await _prefs?.clear();

  //Remove prefs
  static removeprefs(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs
        .remove(key); //Here we have added empty "" if there is no default value
  }
}






// class SharedPrefServicesClass {
//   static void isLogin(BuildContext context) async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     bool? chckLogin = sp.getBool('isLogin');
//     switch (chckLogin) {
//       case true:
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => HomePage(),
//           ),
//         );
//         break;

//       case false:
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => LoginPage()));
//         break;
//       default:
//         Navigator.push(
//             context, MaterialPageRoute(builder: (context) => LoginPage()));
//         break;
//     }
//   }

//   static void insertData(
//       BuildContext context, String userName, String password) async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     sp.setString('email', userName);
//     sp.setString('password', password);
//     sp.setBool('isLogin', true);
//   }

//   static Future<String?> getStringFromKey({required String key}) async {
//     SharedPreferences sp = await SharedPreferences.getInstance();
//     return sp.getString(key);
//   }
// }
