import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfo {
  String? name;
  String? userName;
  String? phoneNumber;
  String? email;
  bool? isTicked;

  UserInfo({
    this.name,
    this.userName,
    this.phoneNumber,
    this.isTicked,
    this.email,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'userName': userName,
    'phoneNumber': phoneNumber,
    'isTicked': isTicked,
    'email': email,
  };

  factory UserInfo.fromJson(Map<String, dynamic> json) => UserInfo(
    name: json['name'],
    userName: json['userName'],
    phoneNumber: json['phoneNumber'],
    isTicked: json['isTicked'],
    email: json['email'],
  );
}

class UserStorage {
  static String userKey = "zelly_shop_user";

  static Future<void> saveUser(UserInfo user) async {
    final prefs = await SharedPreferences.getInstance();
    String tempUser = jsonEncode(user.toJson());
    await prefs.setString(userKey, tempUser);
  }

  // Example function to check if the user has ticked 'Remember me'
  Future<bool> isUserTicked() async {
    UserInfo? user = await UserStorage.loadUser();
    if (user != null && user.isTicked != null) {
      return user.isTicked!;
    }
    return false;
  }

  static Future<UserInfo?> loadUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? tempUser = prefs.getString(userKey);
    if (tempUser != null) {
      Map<String, dynamic> userMap = jsonDecode(tempUser);
      return UserInfo.fromJson(userMap);
    } else {
      return null;
    }
  }

  static Future<void> clearUser() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(userKey);
  }
}
