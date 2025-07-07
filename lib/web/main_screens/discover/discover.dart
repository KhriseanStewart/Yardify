import 'dart:ui';

import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:yardify/widgets/hex.dart';

class DiscoverScreen extends StatelessWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    List<String> categories = [
      'All',
      'Gadgets',
      'Furniture',
      'Vehicle',
      'Fashion',
      'Kids',
      'Collectables',
    ];

    return Scaffold(
      backgroundColor: hexToColor("#F6F6F6"),
      body: size.width >= 300
          ? DesktopSize(categories: categories)
          : Text("data"),
    );
  }
}

class DesktopSize extends StatelessWidget {
  const DesktopSize({super.key, required this.categories});

  final List<String> categories;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Helper functions for responsive sizing
    double widthPercent(double percent) => size.width * percent / 100;
    double heightPercent(double percent) => size.height * percent / 100;
    return ScrollConfiguration(
      behavior: ScrollBehavior().copyWith(
        dragDevices: {
          PointerDeviceKind.mouse,
          PointerDeviceKind.touch,
          PointerDeviceKind.stylus,
        },
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(widthPercent(1)), // 4% padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: widthPercent(1.5),
                  vertical: heightPercent(1),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Left side: Title and Search bar
                    Expanded(
                      child: Row(
                        children: [
                          Text(
                            "Discover",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: widthPercent(2), // 6% of screen width
                            ),
                          ),
                          SizedBox(width: widthPercent(2)),
                          // Search Anchor
                          Expanded(
                            child: TextField(
                              decoration: InputDecoration(
                                hintText: "Search",
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: EdgeInsets.symmetric(
                                  horizontal: widthPercent(2),
                                  vertical: heightPercent(0.8),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    widthPercent(2),
                                  ),
                                  borderSide: BorderSide.none,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: widthPercent(4)),
                    // Right side icons
                    Row(
                      spacing: 10,
                      children: [
                        // Message Icon
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              widthPercent(4),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              FeatherIcons.messageCircle,
                              size: widthPercent(2.5),
                            ),
                          ),
                        ),
                        // Heart Icon
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              widthPercent(4),
                            ),
                          ),
                          child: IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.favorite,
                              color: Colors.redAccent,
                              size: widthPercent(2.5),
                            ),
                          ),
                        ),
                        // Profile
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: widthPercent(1),
                            vertical: heightPercent(1),
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(
                              widthPercent(4),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.person, size: widthPercent(2.5)),
                              SizedBox(width: widthPercent(1)),
                              Text(
                                "Khrisean",
                                style: TextStyle(fontSize: widthPercent(1.8)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: heightPercent(3)),

              // Categories List
              Padding(
                padding: EdgeInsets.symmetric(horizontal: widthPercent(4)),
                child: SizedBox(
                  height: heightPercent(7), // 5% of screen height
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      return Container(
                        margin: EdgeInsets.only(right: widthPercent(2)),
                        padding: EdgeInsets.symmetric(
                          horizontal: widthPercent(2),
                          vertical: heightPercent(1),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(widthPercent(4)),
                        ),
                        child: Center(
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              fontSize: widthPercent(1.5),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              SizedBox(height: heightPercent(3)),
              //special offers
              Text(
                "Special Offers",
                style: TextStyle(
                  fontSize: widthPercent(2),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: size.width >= 400 ? heightPercent(46) : heightPercent(10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return SpecialOfferContainer(index: index);
                  },
                ),
              ),

              SizedBox(height: heightPercent(3)),

              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white),
                      width: double.infinity,
                      child: Text("Hello"),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1,
                      ),
                      itemCount: 10,
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ItemContainer();
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SpecialOfferContainer extends StatelessWidget {
  final int index;
  const SpecialOfferContainer({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double widthPercent(double percent) => size.width * percent / 100;
    double heightPercent(double percent) => size.height * percent / 100;
    return Container(
      margin: EdgeInsets.only(right: 20),
      width: widthPercent(40),
      height: heightPercent(10),
      padding: EdgeInsets.symmetric(horizontal: widthPercent(2)),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(widthPercent(2)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 4,
            offset: Offset(0.5, 1),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 10,
                  children: [
                    Text(
                      "55%",
                      style: TextStyle(
                        fontSize: widthPercent(5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Three Week Special",
                      style: TextStyle(
                        fontSize: widthPercent(1.3),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Get discount on Furniture bought at Pricemart",
                      style: TextStyle(
                        fontSize: widthPercent(1),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(widthPercent(1)),
                  child: Image.asset("assets/web/logo.jpg", fit: BoxFit.cover),
                ),
              ),
            ],
          ),
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            spacing: 6,
            children: [
              Container(
                padding: EdgeInsets.all(4),
                width: index == 0 ? 20 : 6,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                padding: EdgeInsets.all(4),
                width: index == 1 ? 20 : 6,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Container(
                padding: EdgeInsets.all(4),
                width: index == 2 ? 20 : 6,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ItemContainer extends StatelessWidget {
  const ItemContainer({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Helper functions for responsive sizing
    double widthPercent(double percent) => size.width * percent / 100;
    double heightPercent(double percent) => size.height * percent / 100;

    return Container(
      height: heightPercent(30), // Optional: set height if needed
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            blurRadius: 4,
            offset: Offset(0.5, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Use AspectRatio for image height
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(widthPercent(1.5)),
              ),
              child: Image.asset(
                "assets/web/logo.jpg",
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(widthPercent(1.5)),
              ),
            ),
            // Remove fixed height; let content decide
            padding: EdgeInsets.symmetric(vertical: heightPercent(1)),
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Iphone XS",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widthPercent(1.3),
                    fontWeight: FontWeight.w100,
                  ),
                ),
                Text(
                  "\$15,000 JMD",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: widthPercent(1.7),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
