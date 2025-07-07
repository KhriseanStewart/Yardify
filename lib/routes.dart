import 'package:flutter/material.dart';
import 'package:yardify/mobile/auth/authCheck/auth_service.dart';
import 'package:yardify/mobile/auth/forget_password.dart';
import 'package:yardify/mobile/auth/get_started.dart';
import 'package:yardify/mobile/auth/log_in.dart';
import 'package:yardify/mobile/auth/sign_up.dart';
import 'package:yardify/mobile/authGate/auth_gate.dart';
import 'package:yardify/mobile/dashboard/sellers/sellers_dashboard.dart';
import 'package:yardify/mobile/screens/categorys/category_screen.dart';
import 'package:yardify/mobile/screens/discover/discover.dart';
import 'package:yardify/mobile/screens/main_layout/main_layout.dart';
import 'package:yardify/mobile/screens/product/product_screen.dart';
import 'package:yardify/web/auth/screens/log_in.dart';
import 'package:yardify/web/auth/screens/sign_up.dart';
import 'package:yardify/web/main_screens/discover/discover.dart';

final AuthService auth = AuthService();

class WebRouter {
  static const String login = "/";
  static const String signup = "/websignup";
  static const String home = "/home";

  static Map<String, WidgetBuilder> get webroutes {
    return {
      login: (context) => const LogIn(),
      signup: (context) => const SignUp(),
      home: (context) => const DiscoverScreen(),
    };
  }
}

class AppRouter {
  static const String authgate = "/authgate";

  static const String getstarted = "/get-started";
  static const String mobilelogin = "/mobilelogin";
  static const String mobilesignup = "/mobilesignup";
  static const String forgetpassword = "/forgetpassword";

  static const String mainlayout = "/mainlayout";
  static const String mobilediscover = "/mobilediscover";

  static const String mobilecategory = "/mobilecategory";
  static const String mobileproduct = "/mobileproduct";

  static const String mobiledashboard = "/mobiledashboard";


  static Map<String, WidgetBuilder> get approutes {
    return {
      authgate: (context) => AuthGate(),

      getstarted: (context) => GetStarted(auth: auth),
      mobilelogin: (context) => MobileLogIn(auth: auth),
      mobilesignup: (context) => MobileSignUp(),
      forgetpassword: (context) => const ForgetPassword(),

      mainlayout: (context) => const MainLayout(),
      mobilediscover: (context) => const MobileDiscover(),

      mobilecategory: (context) => const CategoryScreen(),
      mobileproduct: (context) => ProductScreen(auth: auth,),

      mobiledashboard: (context) => SellersDashboard(),

    };
  }
}
