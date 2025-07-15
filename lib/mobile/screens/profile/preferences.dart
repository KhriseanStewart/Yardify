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
  bool? themeColor;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getRememberMe();
    getThemeColor();
    print(auth.currentUser);
  }

  Future<void> getRememberMe() async {
    bool? value = await PreferenceManager.getBool();
    setState(() {
      rememberMe = value ?? false; // default to false if null
    });
  }

  Future<void> getThemeColor() async {
    bool? value = await IsDarkTheme.getBool();
    setState(() {
      themeColor = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return rememberMe == null
        ? Scaffold(body: LoadingScreen(color: Colors.black))
        : Scaffold(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            appBar: AppBar(
              title: Text("Preferences"),
              backgroundColor: Theme.of(context).primaryColor,
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                spacing: 20,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Stay logged in"),
                      Switch(
                        value: rememberMe!,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value;
                          });
                          PreferenceManager.saveBool(value);
                        },
                        activeColor:
                            Colors.blue, // The color when the switch is ON
                        inactiveThumbColor:
                            Colors.grey[300], // The thumb color when OFF
                        activeTrackColor:
                            Colors.blue[100], // Track color when ON
                        inactiveTrackColor:
                            Colors.grey[400], // Track color when OFF
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        splashRadius: 20.0, // Optional: size of ripple effect
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Notifications"),
                      Switch(
                        value: rememberMe!,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value;
                          });
                          PreferenceManager.saveBool(value);
                        },
                        activeColor:
                            Colors.blue, // The color when the switch is ON
                        inactiveThumbColor:
                            Colors.grey[300], // The thumb color when OFF
                        activeTrackColor:
                            Colors.blue[100], // Track color when ON
                        inactiveTrackColor:
                            Colors.grey[400], // Track color when OFF
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        splashRadius: 20.0, // Optional: size of ripple effect
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Location"),
                      Switch(
                        value: rememberMe!,
                        onChanged: (value) {
                          setState(() {
                            rememberMe = value;
                          });
                          PreferenceManager.saveBool(value);
                        },
                        activeColor:
                            Colors.blue, // The color when the switch is ON
                        inactiveThumbColor:
                            Colors.grey[300], // The thumb color when OFF
                        activeTrackColor:
                            Colors.blue[100], // Track color when ON
                        inactiveTrackColor:
                            Colors.grey[400], // Track color when OFF
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        splashRadius: 20.0, // Optional: size of ripple effect
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Theme / Appearance"),
                      Switch(
                        value: themeColor!,
                        onChanged: (value) {
                          IsDarkTheme.saveBool(value);
                          setState(() {
                            themeColor = value;
                          });
                        },
                        activeColor:
                            Colors.blue, // The color when the switch is ON
                        inactiveThumbColor:
                            Colors.grey[300], // The thumb color when OFF
                        activeTrackColor:
                            Colors.blue[100], // Track color when ON
                        inactiveTrackColor:
                            Colors.grey[400], // Track color when OFF
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        splashRadius: 20.0, // Optional: size of ripple effect
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }
}
