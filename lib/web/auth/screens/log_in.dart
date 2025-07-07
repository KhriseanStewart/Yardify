import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:yardify/routes.dart';
import 'package:yardify/widgets/custom_button.dart';
import 'package:yardify/widgets/hex.dart';
import 'package:yardify/widgets/snack_bar.dart';

class LogIn extends StatefulWidget {
  const LogIn({super.key});

  @override
  State<LogIn> createState() => _LogInState();
}

bool rememberMe = false;
bool _obscureField = true;
final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();
final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

class _LogInState extends State<LogIn> {
  @override
  Widget build(BuildContext context) {
    void logInAuth() {
      String email = _emailController.text.trim();
      String password = _passwordController.text;
      if (_globalKey.currentState!.validate()) {
        if (email.isNotEmpty) {
          if (password.isNotEmpty) {
            Navigator.pushNamed(context, WebRouter.home);
          }
        }
      } else {
        displaySnackBar(context, "Form is invalid");
      }
    }

    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: hexToColor('#e7e5b5'),
      body: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AspectRatio(
                  aspectRatio: size.aspectRatio,
                  child: Image.asset(
                    "assets/web/logo.jpg",
                    fit: BoxFit.contain,
                    height: size.height,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 400,
                    child: Form(
                      key: _globalKey,
                      child: Column(
                        spacing: 20,
                        children: [
                          Text(
                            "Log In",
                            style: TextStyle(
                              fontSize: 34,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Email",
                            ),
                            validator: (value) {
                              if (value!.isEmpty) return "Enter email";
                              return null;
                            },
                          ),
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Password",
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    _obscureField = !_obscureField;
                                  });
                                },
                                icon: Icon(
                                  _obscureField
                                      ? Icons.visibility
                                      : Icons.visibility_off_outlined,
                                ),
                              ),
                            ),
                            obscureText: _obscureField,
                            validator: (value) {
                              if (value!.isEmpty) return "Enter Password";
                              return null;
                            },
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value!;
                                  });
                                },
                              ),
                              Text("Remember me"),
                            ],
                          ),
                          CustomButton(
                            btntext: "Log In",
                            onpress: () {
                              logInAuth();
                            },
                            isBoldtext: true,
                            size: 24,
                            textcolor: Colors.black,
                            bgcolor: Colors.white,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [Text("or continue with")],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            spacing: 40,
                            children: [
                              IconContainer(
                                icons: Icon(FontAwesomeIcons.google, size: 34),
                              ),
                              IconContainer(
                                icons: Icon(
                                  FontAwesomeIcons.facebook,
                                  size: 34,
                                ),
                              ),
                              IconContainer(
                                icons: Icon(FontAwesomeIcons.apple, size: 34),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account?"),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                    context,
                                    WebRouter.signup,
                                  );
                                },
                                child: Text("Sign Up"),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IconContainer extends StatelessWidget {
  final Icon icons;
  const IconContainer({super.key, required this.icons});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(),
        borderRadius: BorderRadius.circular(10),
      ),
      child: icons,
    );
  }
}
