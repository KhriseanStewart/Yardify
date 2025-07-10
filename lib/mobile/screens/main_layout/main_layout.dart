import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';
import 'package:yardify/mobile/screens/discover/discover.dart';
import 'package:yardify/mobile/screens/favorites/favorites.dart';
import 'package:yardify/mobile/screens/profile/profile_tabs.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

List<Widget> _screens = [MobileDiscover(), FavoriteScreen(), ProfileTabs()];
bool showBage = false;
void checkBadge() {}
int _currentIndex = 0;

class _MainLayoutState extends State<MainLayout> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: _screens[_currentIndex],
      bottomNavigationBar: StylishBottomBar(
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        items: [
          BottomBarItem(
            selectedColor: Colors.black,
            icon: const Icon(Icons.home),
            title: const Text("Discover"),
          ),
          BottomBarItem(
            badge: Text("data"),
            showBadge: showBage,
            selectedColor: Colors.black,
            icon: const Icon(Icons.favorite),
            title: const Text("Favorite"),
          ),
          BottomBarItem(
            icon: const Icon(Icons.person),
            title: const Text("Profile"),
            selectedColor: Colors.black,
          ),
        ],
        option: BubbleBarOptions(),
      ),
      // bottomNavigationBar: SalomonBottomBar(
      //   backgroundColor: Colors.white,
      //   selectedItemColor: Colors.black,
      //   unselectedItemColor: Colors.grey.shade400,
      //   currentIndex: _currentIndex,
      //   onTap: (index) {
      //     setState(() {
      //       _currentIndex = index;
      //     });
      //   },
      //   items: [
      //     SalomonBottomBarItem(
      //       icon: const Icon(Icons.home),
      //       title: const Text("Discover"),
      //     ),
      //     SalomonBottomBarItem(
      //       icon: const Icon(Icons.favorite),
      //       title: const Text("Favorites"),
      //     ),
      //     SalomonBottomBarItem(
      //       icon: const Icon(Icons.person),
      //       title: const Text("Profile"),
      //     ),
      //   ],
      // ),
    );
  }
}
