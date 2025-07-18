import 'package:flutter/material.dart';
import 'package:yardify/mobile/database/item_list.dart';
import 'package:yardify/mobile/screens/profile/preferences.dart';
import 'package:yardify/mobile/screens/profile/profile.dart';
import 'package:yardify/routes.dart';

class ProfileTabs extends StatelessWidget {
  const ProfileTabs({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            tooltip: 'Log out',
            style: IconButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColorLight,
            ),
            onPressed: () {
              ProductService().logout();
              Navigator.pushReplacementNamed(context, AppRouter.authgate);
            },
            icon: Icon(Icons.logout_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Column(
          spacing: 30,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,

          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(300),
                  child: Container(
                    width: 150,
                    height: 150,
                    padding: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade400,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(300),
                      child: ProfileImageWidget(),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              spacing: 10,
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, AppRouter.mobiledashboard);
                      },
                      title: Text(
                        "Sellers Dashboard",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.labelMedium?.color,
                        ),
                      ),
                      subtitle: Text(
                        "Start selling your Items Today!",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.labelMedium?.color,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    decoration: BoxDecoration(
                      color: Colors.yellow.shade200,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListTile(
                      onTap: () {
                        //move to Ads Dashboard
                      },
                      title: Text(
                        "Post Ads",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).textTheme.labelMedium?.color,
                        ),
                      ),
                      subtitle: Text(
                        "Get your items seen with our Ads",
                        style: TextStyle(
                          color: Theme.of(context).textTheme.labelMedium?.color,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    title: Text("Account Information"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProfileScreen(title: "Profile", signup: false),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(
                    title: Text("Preferences"),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreferenceScreen(),
                        ),
                      );
                    },
                  ),
                  Divider(),
                  ListTile(title: Text("Following")),
                  Divider(),
                  ListTile(title: Text("Settings")),
                  Divider(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
