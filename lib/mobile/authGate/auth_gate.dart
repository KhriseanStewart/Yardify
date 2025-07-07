import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yardify/mobile/auth/get_started.dart';
import 'package:yardify/mobile/auth/log_in.dart';
import 'package:yardify/mobile/screens/main_layout/main_layout.dart';
import 'package:yardify/mobile/screens/profile/profile.dart';
import 'package:yardify/routes.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final requiredFields = ['name', 'telephone', 'profilePic', 'email', 'username'];
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          //if logged in
          if (snapshot.hasData) {
            final user = snapshot.data!;
            if (user.uid.isEmpty) {
              return MobileLogIn(auth: auth);
            }
            return StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection("users")
                  .doc(user.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasData && snapshot.data!.exists) {
                  final userData =
                      snapshot.data!.data() as Map<String, dynamic>;

                  bool isProfileCompleted = true;

                  for (var field in requiredFields) {
                    if (userData[field] == null ||
                        userData[field].toString().isEmpty) {
                      print(field);
                      isProfileCompleted = false;
                      break;
                    }
                  }
                  if (isProfileCompleted == true) {
                    return MainLayout();
                  }
                  return ProfileScreen(
                    title: "Fill in your Profile",
                    signup: true,
                  );
                } else {
                  return ProfileScreen(
                    title: "Fill in your Profile",
                    signup: true,
                  );
                }
              },
            );
          } else {
            return GetStarted(auth: auth);
          }
        },
      ),
    );
  }
}
