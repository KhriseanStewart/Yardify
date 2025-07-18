// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:yardify/mobile/auth/authCheck/auth_service.dart';
import 'package:yardify/mobile/database/item_list.dart';
import 'package:yardify/mobile/database/shared_preference.dart';
import 'package:yardify/mobile/screens/profile/profile.dart';
import 'package:yardify/routes.dart';
import 'package:yardify/widgets/custom_button.dart';
import 'package:yardify/widgets/snack_bar.dart';

class GetStarted extends StatefulWidget {
  final AuthService auth;
  const GetStarted({super.key, required this.auth});

  @override
  State<GetStarted> createState() => _GetStartedState();
}

class _GetStartedState extends State<GetStarted> {
  @override
  void initState() {
    super.initState();
    UserService().requestPermissions();
    _checkPermissions();
    checkRememberMe();
  }

  void _checkPermissions() async {
    bool permsGranted = await Permissions().requestPerms();
    if (permsGranted) {}
  }

  void checkRememberMe() async {
    final data = await PreferenceManager.getBool();
    if (data != null && data == true) {
      final user = widget.auth.currentUser;
      if (user != null) {
        checkUserDocument(user.uid);
      }
    }
  }

  void checkUserDocument(String uid) async {
    try {
      final userData = await UserService().db
          .collection("users")
          .doc(uid)
          .get();
      if (userData.exists) {
        Navigator.pushReplacementNamed(context, AppRouter.authgate);
      } else {
        displaySnackBar(context, "Complete the Profile Form");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ProfileScreen(title: "Fill Your Profile", signup: true),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      displaySnackBar(context, "An error occured ");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          spacing: 20,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/mobile/get-started.png", fit: BoxFit.fill),
            Text(
              "Let's get you settled",
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
            CustomButton(
              btntext: "Continue with Google",
              bgcolor: Colors.white,
              textcolor: Colors.black,
              isBoldtext: true,
              onpress: () {
                // Handle Google sign-in
              },
            ),

            CustomButton(
              btntext: "Continue with Facebook",
              bgcolor: Colors.white,
              textcolor: Colors.black,
              isBoldtext: true,
              onpress: () {
                // Handle Facebook sign-in
              },
            ),
            Theme.of(context).platform == TargetPlatform.iOS
                ? CustomButton(
                    btntext: "Continue with Apple",
                    bgcolor: Colors.white,
                    textcolor: Colors.black,
                    isBoldtext: true,
                    onpress: () {
                      // Handle Apple sign-in
                    },
                  )
                : Container(),
            Text("or", style: TextStyle(fontSize: 16, color: Colors.black)),
            CustomButton(
              btntext: "Sign up with Email & Password",
              bgcolor: Colors.black,
              textcolor: Colors.white,
              isBoldtext: true,
              onpress: () {
                Navigator.pushReplacementNamed(context, AppRouter.authgate);
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Already have an account? ",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, AppRouter.authgate);
                  },
                  child: Text("Log in"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
