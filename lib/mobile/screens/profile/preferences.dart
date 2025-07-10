import 'package:flutter/material.dart';
import 'package:yardify/mobile/database/shared_preference.dart';
import 'package:yardify/routes.dart';
import 'package:yardify/widgets/loading.dart';

class PreferenceScreen extends StatefulWidget {
  const PreferenceScreen({super.key});

  @override
  State<PreferenceScreen> createState() => _PreferenceScreenState();
}

class _PreferenceScreenState extends State<PreferenceScreen> {
  bool? rememberMe;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRememberMe();
    print(auth.currentUser);
  }

  Future<void> getRememberMe() async {
    bool? value = await PreferenceManager.getBool();
    setState(() {
      rememberMe = value ?? false; // default to false if null
    });
  }

  @override
  Widget build(BuildContext context) {
    return rememberMe == null
        ? Scaffold(body: LoadingScreen(color: Colors.black))
        : Scaffold(
            appBar: AppBar(title: Text("Preferences")),
            body: Column(
              children: [
                Text("Authentification"),
                Switch(
                  value: rememberMe!,
                  onChanged: (value) {
                    setState(() {
                      rememberMe = value;
                    });
                    PreferenceManager.saveBool(value);
                  },
                ),
              ],
            ),
          );
  }
}
