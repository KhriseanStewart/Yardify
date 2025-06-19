import 'package:flutter/material.dart';
import 'package:zellyshop/auth/login.dart';
import 'package:zellyshop/auth/profile_login.dart';
import 'package:zellyshop/auth/signup.dart';
import 'package:zellyshop/screen/cart/carts.dart';
import 'package:zellyshop/screen/home/home.dart';
import 'package:zellyshop/screen/item/item.dart';
import 'package:zellyshop/screen/main/layout.dart';
import 'package:zellyshop/screen/profle/edit_profile.dart';


class AppRoutes {
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main = '/main';
  static const String home = '/home';
  static const String cart = '/cart';
  static const String item = '/item';
  static const String editprofile = '/editprofile';
  static const String loginprofile = '/loginprofile';



  static Map<String, WidgetBuilder> get routes {
    return {
      login: (context) => const Login(),
      signup: (context) => const SignUp(),
      main: (context) => const MainLayout(),
      home: (context) => const HomeScreen(),
      cart: (context) => const Cart(),
      item: (context) => const ProductItem(),
      editprofile: (context) => const EditProfile(),
      loginprofile: (context) => const ProfileLogin(),
    };
  }
}
