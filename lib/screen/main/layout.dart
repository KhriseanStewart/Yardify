import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';
import 'package:zellyshop/screen/fav/favourites.dart';
import 'package:zellyshop/screen/home/home.dart';
import 'package:zellyshop/screen/profle/profileScreen.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

int _currentIndex = 0;

final List<Widget> _screen = const [
  HomeScreen(),
  Favourites(),
  Profilescreen(),
];

class _MainLayoutState extends State<MainLayout> {
  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screen[_currentIndex],
      bottomNavigationBar: SalomonBottomBar(
        onTap: _onTap,
        currentIndex: _currentIndex,
        backgroundColor: Colors.transparent,
        curve: Curves.fastEaseInToSlowEaseOut,
        duration: Duration(milliseconds: 600),
        selectedItemColor: Colors.lightBlueAccent.shade400,
        unselectedItemColor: Colors.grey.shade500,
        items: [
          SalomonBottomBarItem(
            icon: Icon(Icons.home_filled),
            title: Text("Home"),
          ),
          SalomonBottomBarItem(
            icon: Icon(Icons.favorite),
            title: Text("Favourites"),
          ),
          SalomonBottomBarItem(
            icon: Icon(FontAwesomeIcons.user),
            title: Text("Profile"),
          ),
        ],
      ),
    );
  }
}
