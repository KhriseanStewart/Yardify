import 'package:flutter/material.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:yardify/mobile/database/favorite_data.dart';
import 'package:yardify/mobile/screens/discover/discover.dart';
import 'package:yardify/mobile/screens/favorites/favorites.dart';
import 'package:yardify/mobile/screens/profile/profile_tabs.dart';
import 'package:yardify/routes.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

int badgeCount = 0;
List<Widget> _screens = [MobileDiscover(), FavoriteScreen(), ProfileTabs()];
bool showBage = true;
void checkBadge() {}
int _currentIndex = 0;

void badgetext() {
  FavoriteData().readFav(auth.currentUser!.uid);
}

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: _screens[_currentIndex],
      bottomNavigationBar: StreamBuilder(
        stream: FavoriteData().readFav(auth.currentUser!.uid),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            // handle error
            badgeCount = 0;
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            // loading state
            badgeCount = 0;
          } else if (snapshot.hasData) {
            // get the number of documents
            badgeCount = snapshot.data!.docs.length;
          } else {
            badgeCount = 0;
          }
          return StylishBottomBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            currentIndex: _currentIndex,
            items: [
              BottomBarItem(
                selectedColor: Theme.of(context).primaryColorLight,
                icon: const Icon(Icons.home),
                title: const Text("Discover"),
              ),
              BottomBarItem(
                badge: Text(
                  "$badgeCount",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                showBadge: showBage,
                selectedColor: Theme.of(context).primaryColorLight,
                icon: const Icon(Icons.favorite),
                title: const Text("Favorite"),
              ),
              BottomBarItem(
                icon: const Icon(Icons.person),
                title: const Text("Profile"),
                selectedColor: Theme.of(context).primaryColorLight,
              ),
            ],
            option: BubbleBarOptions(),
          );
        },
      ),
    );
  }
}
