import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yardify/mobile/auth/log_in.dart';
import 'package:yardify/mobile/database/check_internet.dart';
import 'package:yardify/mobile/screens/main_layout/main_layout.dart';
import 'package:yardify/mobile/screens/profile/profile.dart';
import 'package:yardify/routes.dart';
import 'package:yardify/widgets/loading.dart';

class AuthGate extends StatefulWidget {
  const AuthGate({super.key});

  @override
  State<AuthGate> createState() => _AuthGateState();
}

class _AuthGateState extends State<AuthGate> {
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    CheckInternet().checkInitialConnectivity(_connectivity, context);
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      updateConnStat,
    );
  }

  Future<void> updateConnStat(List<ConnectivityResult> result) async {
    CheckInternet().updateConnectionStatus(result, context);
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _refreshPage() async {
    await Future.delayed(Duration(seconds: 2));
    try {
      final result = await _connectivity.checkConnectivity();
      updateConnStat(result);
    } catch (e) {
      print('Error checking connectivity: $e');
    }
    setState(() {
      // Your data refresh logic
    });
  }

  @override
  Widget build(BuildContext context) {
    final requiredFields = ['name', 'telephone', 'email', 'username'];
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _refreshPage,
        triggerMode: RefreshIndicatorTriggerMode.onEdge,
        child: StreamBuilder(
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
                    return LoadingScreen(color: Colors.black);
                  }
                  if (snapshot.connectionState == ConnectionState.none) {
                    return LoadingScreen(color: Colors.red);
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
              return MobileLogIn(auth: auth);
            }
          },
        ),
      ),
    );
  }
}
