// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yardify/mobile/auth/authCheck/auth_service.dart';
import 'package:yardify/mobile/database/item_list.dart';
import 'package:yardify/mobile/screens/profile/profile.dart';
import 'package:yardify/routes.dart';
import 'package:yardify/widgets/constant.dart';
import 'package:yardify/widgets/custom_button.dart';
import 'package:yardify/widgets/snack_bar.dart';

class MobileSignUp extends StatefulWidget {
  const MobileSignUp({super.key});

  @override
  State<MobileSignUp> createState() => _MobileSignUpState();
}

class _MobileSignUpState extends State<MobileSignUp> {
  final _signUpKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();
  bool isLoading = false;

  void handlesubmit() async {
    if (_signUpKey.currentState?.validate() ?? false) {
      setState(() {
        isLoading = true;
      });
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      final String rePassword = _rePasswordController.text.trim();

      if (password != rePassword) {
        displaySnackBar(context, "Passwords do not match");
        setState(() {
          isLoading = false;
        });
        return;
      } else {
        AuthService auth = AuthService();
        try {
          User? result = await auth.register(email, password, context);
          if (result?.uid != null || result!.uid.isNotEmpty) {
            UserService().updateProfilePic(result!.uid, '');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(title: 'Fill your Profile', signup: true),
              ),
            );
          }
        } catch (e) {
          displaySnackBar(context, "Sign-up failed: $e");
        } finally {
          setState(() {
            isLoading = false;
          });
          // Clear the text fields after submission
          _emailController.clear();
          _passwordController.clear();
          _rePasswordController.clear();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: SizedBox(
            height: SizeConfig.screenHeight,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              spacing: 14,
              children: [
                Image.asset(
                  "assets/mobile/vecteezy_iphone-14-pro-screen-template-next-to-a-surprised-man_13337961.jpg",
                  height: 250,
                  width: 250,
                ),
                Text(
                  "Create your account",
                  style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                ),
                Form(
                  key: _signUpKey,
                  child: Column(
                    spacing: 16,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: "Email",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: "Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                      ),
                      TextFormField(
                        controller: _rePasswordController,
                        decoration: InputDecoration(
                          labelText: "Re Enter Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomButton(
                  btntext: "Sign Up",
                  bgcolor: isLoading ? Colors.grey.shade300 : Colors.black,
                  textcolor: Colors.white,
                  isBoldtext: true,
                  size: 18,
                  onpress: isLoading ? null : handlesubmit,
                ),
                Text(
                  "Or continue with",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 30,
                  children: [
                    logInWithThirdParty(
                      Icon(
                        FontAwesomeIcons.google,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                    logInWithThirdParty(
                      Icon(
                        FontAwesomeIcons.facebook,
                        color: Colors.lightBlueAccent,
                        size: 30,
                      ),
                    ),
                    logInWithThirdParty(
                      Icon(
                        FontAwesomeIcons.apple,
                        color: Colors.black,
                        size: 30,
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Already have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRouter.mobilelogin,
                        );
                      },
                      child: Text("Log in"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget logInWithThirdParty(Icon icon) {
    return GestureDetector(
      onTap: () {
        // Handle Google sign-in
      },
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(10),
        child: icon,
      ),
    );
  }
}
