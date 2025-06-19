// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:zellyshop/auth/db/secure_storage_user_info.dart';
import 'package:zellyshop/auth/db/secure_storage_pin.dart';
import 'package:zellyshop/auth/db/sharedpref_user_info.dart';
import 'package:zellyshop/database/auth_service.dart';
import 'package:zellyshop/widget/appRoutes.dart';
import 'package:zellyshop/widget/custom_btn_v2.dart';
import 'package:zellyshop/widget/misc.dart';
import 'package:zellyshop/widget/textfield.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

final TextEditingController emailController = TextEditingController();
final TextEditingController passwordController = TextEditingController();

final _login = GlobalKey<FormState>();

bool isTicked = false;
bool _isObscure = true;
final rememberMe = UserStorage().isUserTicked();

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    _loadRememberMeStatus();
    checkUserRememberMe();
    AuthService().hasBiometrics();
  }

  void _loadRememberMeStatus() async {
    bool remembered = await UserStorage().isUserTicked();
    setState(() {
      isTicked = remembered;
    });
  }

  void checkUserRememberMe() async {
    if (await rememberMe) {
      fetchUserCredentials();
    }
  }

  void biometrics() async {
    final checkDevice = AuthService().auth.canCheckBiometrics;
    if (await checkDevice) {
      AuthService().authenticiateWithBio();
      displaySnackBar(context, "This device has BIO");
    } else {
      displaySnackBar(context, "This device doesnt seem to support biometrics");
    }
  }

  void signInBio() async {
    final checkDevice = AuthService().auth.canCheckBiometrics;
    if (await checkDevice) {
      AuthService().hasBiometrics();
    } else {
      displaySnackBar(context, "This device doesnt seem to support biometrics");
    }
  }

  void _obscureText() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  void fetchUserCredentials() async {
    final storage = SecureStorageServiceUserInfo();
    final credentials = await storage.getUserCredentials();

    if (credentials != null) {
      String? email = credentials['email'];
      String? password = credentials['password'];
      print('Email: $email');
      print('Password: $password');
      emailController.text = email ?? '';
      passwordController.text = password ?? '';
    } else {
      displaySnackBar(context, "Credentials not found");
    }
  }

  @override
  Widget build(BuildContext context) {
  
    void logInUser() async {
      final storage = SecureStorageServiceUserInfo();
      final data = await storage.getUserCredentials();
      String? email = emailController.text;
      String? password = passwordController.text;

      if (data != null) {
        if (email == data['email'] || password == data['password']) {
          await UserStorage.saveUser(
            UserInfo( 
              isTicked: isTicked,
            ),
          );
          Navigator.pushReplacementNamed(context, AppRoutes.main);
        } else if (email != data['email']) {
          displaySnackBar(context, "Invalid Email");
        } else if (password != data['password']) {
          displaySnackBar(context, "Invalid Email");
        } else {
          displaySnackBar(context, "Something went wrong");
        }
      }
    }

    return Scaffold(
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
                    key: _login,
                    child: Column(
                      children: [
                        Text(
                          "Log In",
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
                              return 'Enter Password';
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
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Checkbox(
                        value: isTicked,
                        onChanged: (value) async {
                          setState(() {
                            isTicked = value ?? false;
                          });
                          if (isTicked) {
                            await SecureStorageServiceUserInfo().saveUser(
                              emailController.text,
                              passwordController.text,
                            );
                          }
                        },
                        activeColor: Colors.white,
                        checkColor: Colors.black,
                      ),
                      Text(
                        "Remember me",
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    spacing: 10,
                    children: [
                      GestureDetector(
                        onTap: () {
                          // biometrics();
                          displaySnackBar(context, "Feature in development");
                        },
                        child: Tooltip(
                          message: 'Sign up for Biometrics',
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
                          message: 'Log in With Pin',
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
                                "PIN Log In",
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
                          btntext: "Log In",
                          bgcolor: Colors.grey.shade300,
                          isBoldtext: true,
                          onpress: () async {
                            logInUser();
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
                        "Don't have an account?",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade900,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(
                            context,
                            AppRoutes.signup,
                          );
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
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
                String? storedPin = await SecureStorageService().getToken();
                if (pin.length != 4) {
                  displaySnackBar(context, "Enter at least 4 digits");
                  print(storedPin);
                  return;
                } else if (pin == storedPin) {
                  displaySnackBar(context, "Successfully Logged In");

                  print(storedPin);
                  Navigator.pushReplacementNamed(context, AppRoutes.main);
                }
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
