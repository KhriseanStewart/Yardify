// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zellyshop/auth/db/secure_storage_user_info.dart';
import 'package:zellyshop/auth/db/secure_storage_pin.dart';
import 'package:zellyshop/database/auth_service.dart';
import 'package:zellyshop/widget/appRoutes.dart';
import 'package:zellyshop/widget/custom_btn_v2.dart';
import 'package:zellyshop/widget/misc.dart';
import 'package:zellyshop/widget/textfield.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController authPasswordController = TextEditingController();
final _signUp = GlobalKey<FormState>();

bool isTicked = false;
bool _isObscure = true;

class _SignUpState extends State<SignUp> {
  @override
  void initState() {
    super.initState();
    biometricsCheck();
  }

  void _obscureText() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void onPinSetup(String pin) async {
    if (pin.length != 4) {
      displaySnackBar(context, "Enter at least 4 digits");
      return;
    } else {
      await SecureStorageService().saveToken(pin);
      Future.delayed(Duration(milliseconds: 400), () {
        displaySnackBar(context, "Pin set");
      });
      Navigator.of(context).pop();
    }
  }

  void authServiceSave() {
    SecureStorageServiceUserInfo().saveUser(
      emailController.text.trim(),
      passwordController.text,
    );
  }

  void signupuser() async {
    final storage = SecureStorageServiceUserInfo();
    String? email = emailController.text;
    String? password = passwordController.text;
    String? passwordAuth = authPasswordController.text;

    authServiceSave();

    if (password == passwordAuth) {
      storage.saveUser(email, password);
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.loginprofile,
        arguments: {'email': emailController.text},
      );
    } else {
      displaySnackBar(context, "An error happened somewhere");
    }
  }

  void biometricsCheck() async {
    final checkDevice = AuthService().auth.canCheckBiometrics;
    if (await checkDevice) {
      AuthService().hasBiometrics;
      displaySnackBar(context, "This device has BIO");
    } else {
      displaySnackBar(context, "This device doesnt seem to support biometrics");
    }
  }

  // Future<void> _authWithBio() async {
  //   try {
  //     AuthService().authenticiateWithBio();
  //   } on PlatformException catch (e) {
  //     print(e);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  const Color.fromARGB(255, 142, 203, 253),
                  const Color.fromARGB(255, 0, 138, 202),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20),
            child: Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Form(
                    key: _signUp,
                    child: Column(
                      children: [
                        Text(
                          "Sign Up",
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 15),
                        Textfield(
                          keyboardType: TextInputType.emailAddress,
                          textlabel: "Enter Email",
                          texticon: Icon(Icons.email),
                          textcontroller: emailController,
                          val: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Email';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Textfield(
                          keyboardType: TextInputType.visiblePassword,
                          textlabel: "Enter Password",
                          texticon: Icon(Icons.password_outlined),
                          iconbutton: IconButton(
                            onPressed: _obscureText,
                            icon: Icon(
                              _isObscure
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                          obscuretext: _isObscure,
                          textcontroller: passwordController,
                          val: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Password';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        Textfield(
                          keyboardType: TextInputType.visiblePassword,
                          textlabel: "Re Enter Password",
                          texticon: Icon(Icons.password_outlined),
                          obscuretext: true,
                          textcontroller: authPasswordController,
                          val: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Enter Password';
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    spacing: 10,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // biometricsCheck();
                          // _authWithBio();
                          displaySnackBar(context, "Feature in development");
                        },
                        child: Tooltip(
                          message: 'Check & Bio',
                          child: Container(
                            height: 50,
                            width: 98,
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(child: Icon(Icons.fingerprint)),
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          showPinDialog(context);
                        },
                        child: Tooltip(
                          message: 'Add PIN',
                          child: Container(
                            height: 50,
                            width: 98,
                            padding: EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey.shade400,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                "Setup PIN",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: CustomBtnV2(
                          btntext: "Sign Up",
                          bgcolor: Colors.grey.shade300,
                          isBoldtext: true,
                          onpress: () {
                            if (_signUp.currentState!.validate()) {
                              signupuser();
                            }
                          },
                          textcolor: Colors.black,
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade900,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                context,
                                AppRoutes.login,
                              );
                            },
                            child: Text(
                              "Log In",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> showPinDialog(BuildContext context) async {
    String pin = '';

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text('Enter PIN')),
          content: TextFormField(
            obscureText: true,
            keyboardType: TextInputType.number,
            onChanged: (value) {
              pin = value;
            },
            validator: (pin) {
              if (pin!.isEmpty) {
                return 'Fill out the PIN field';
              }
              return null;
            },
            decoration: InputDecoration(hintText: 'PIN'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                onPinSetup(pin);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );

    // After dialog is dismissed, you can process the entered PIN
    print('Entered PIN: $pin');
  }
}
