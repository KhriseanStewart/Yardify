// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yardify/mobile/auth/authCheck/auth_service.dart';
import 'package:yardify/mobile/database/shared_preference.dart';
import 'package:yardify/routes.dart';
import 'package:yardify/widgets/constant.dart';
import 'package:yardify/widgets/custom_button.dart';
import 'package:yardify/widgets/snack_bar.dart';

class MobileLogIn extends StatefulWidget {
  final AuthService auth;
  const MobileLogIn({super.key, required this.auth});

  @override
  State<MobileLogIn> createState() => _MobileLogInState();
}

class _MobileLogInState extends State<MobileLogIn> {
  bool rememberMe = false;
  bool isLogin = true;
  final _loginKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void login() async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    if (_loginKey.currentState?.validate() ?? false) {
      try {
        final auth = await widget.auth.login(email, password);
        if (auth == null) {
          displaySnackBar(
            context,
            "Incorrect email or password",
            backgroundColor: Colors.red,
            textColor: Colors.white,
          );
          return;
        }

        await PreferenceManager.saveBool(rememberMe);
      } on FirebaseAuth catch (e) {
        displaySnackBar(context, "Login failed: $e");
        return;
      }
      if (!mounted) return;
      // Navigate to the next screen after successful login
      Navigator.pushReplacementNamed(context, AppRouter.authgate);
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double sizing = SizeConfig.appPadding;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: SizeConfig.screenHeight,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: sizing),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 14,
                children: [
                  Image.asset(
                    "assets/mobile/vecteezy_iphone-14-pro-screen-template-next-to-a-surprised-man_13337961.jpg",
                    width: SizeConfig.widthPercentage(50),
                  ),
                  Text(
                    "Log In your account",
                    style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
                  ),
                  Form(
                    key: _loginKey,
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Checkbox(
                                  value: rememberMe,
                                  onChanged: (value) {
                                    setState(() {
                                      rememberMe = value ?? false;
                                    });
                                  },
                                ),
                                Text("Remember me"),
                              ],
                            ),
                            Row(
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRouter.forgetpassword,
                                    ); // Adjust the route as needed
                                  },
                                  child: Text("Forgot Password?"),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  CustomButton(
                    btntext: "Log In",
                    bgcolor: Colors.black,
                    textcolor: Colors.white,
                    isBoldtext: true,
                    size: 18,
                    onpress: login,
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
                      Text("Don't have an account? "),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRouter.mobilesignup,
                          ); // Adjust the route as needed
                        },
                        child: Text("Sign Up"),
                      ),
                    ],
                  ),
                ],
              ),
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
