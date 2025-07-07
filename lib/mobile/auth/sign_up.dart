import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yardify/mobile/auth/authCheck/auth_service.dart';
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

final _signUpKey = GlobalKey<FormState>();
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final TextEditingController _rePasswordController = TextEditingController();

class _MobileSignUpState extends State<MobileSignUp> {
  void handlesubmit() async {
    if (_signUpKey.currentState?.validate() ?? false) {
      final String email = _emailController.text.trim();
      final String password = _passwordController.text.trim();
      final String rePassword = _rePasswordController.text.trim();

      if (password != rePassword) {
        displaySnackBar(context, "Passwords do not match");
        return;
      } else {
        AuthService auth = AuthService();
        try {
          auth.register(email, password);
        } catch (e) {
          displaySnackBar(context, "Sign-up failed: $e");
          return;
        } finally {
          // Clear the text fields after submission
          _emailController.clear();
          _passwordController.clear();
          _rePasswordController.clear();

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProfileScreen(title: "Fill Your Profile", signup: true),
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
                Image.asset("assets/mobile/logo.png", height: 250, width: 250),
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
                  bgcolor: Colors.black,
                  textcolor: Colors.white,
                  isBoldtext: true,
                  size: 18,
                  onpress: handlesubmit,
                ),
                Text(
                  "Or continue with",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  spacing: 30,
                  children: [
                    LogInWithThirdParty(
                      Icon(
                        FontAwesomeIcons.google,
                        color: Colors.red,
                        size: 30,
                      ),
                    ),
                    LogInWithThirdParty(
                      Icon(
                        FontAwesomeIcons.facebook,
                        color: Colors.lightBlueAccent,
                        size: 30,
                      ),
                    ),
                    LogInWithThirdParty(
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

  Widget LogInWithThirdParty(Icon icon) {
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
