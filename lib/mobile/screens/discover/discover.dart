import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yardify/mobile/database/check_internet.dart';
import 'package:yardify/mobile/database/item_list.dart';
import 'package:yardify/mobile/screens/product/dis_product_card.dart';
import 'package:yardify/routes.dart';
import 'package:yardify/widgets/constant.dart';
import 'package:yardify/widgets/loading.dart';

class MobileDiscover extends StatefulWidget {
  const MobileDiscover({super.key});

  @override
  State<MobileDiscover> createState() => _MobileDiscoverState();
}

bool isFavorite = false;
final SearchController searchController = SearchController();

class _MobileDiscoverState extends State<MobileDiscover> {
  final CheckInternet checkInternet = CheckInternet();
  late final Connectivity _connectivity;
  late final StreamSubscription<List<ConnectivityResult>>
  _connectivitySubscription;
  bool isConnected = true;
  List<ConnectivityResult> _connectionStatus = [ConnectivityResult.none];

  @override
  void initState() {
    super.initState();
    _connectivity = Connectivity();
    checkInternet.checkInitialConnectivity(_connectivity, context);
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      checkInternet.updateConnectionStatus(result, context);
      setState(() {
        _connectionStatus = result;
        hasConnection(_connectionStatus);
      });
    });
  }


  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  void hasConnection(List<ConnectivityResult> result) {
    if (result.contains(ConnectivityResult.wifi)) {
      setState(() {
        isConnected = true;
      });
    } else {
      isConnected = false;
    }
    print(_connectionStatus);
    print("connection status: $isConnected");
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final itemList = ProductService().getItems();
    final adsList = ProductService().getAds();
    //this might cause the screens to not load properly
    return StreamBuilder<QuerySnapshot>(
      stream: itemList,
      builder: (context, snapshot) {
        List<QueryDocumentSnapshot> items = [];
        if (snapshot.hasData) {
          items = snapshot.data!.docs;
        }
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildHeader(),
                    buildSearchBar(items, snapshot),
                    SizedBox(height: 8),
                    SizedBox(height: 220, child: buildStreamAds(adsList)),
                    buildStreamList(categories, itemList),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget buildSearchBar(
    List<QueryDocumentSnapshot<Object?>> items,
    AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(width: 0.3),
      ),
      child: SearchAnchor.bar(
        barElevation: WidgetStatePropertyAll(0),
        barBackgroundColor: WidgetStatePropertyAll(Colors.white),
        barHintText: "Search",
        searchController: searchController,
        suggestionsBuilder: (context, controller) {
          final input = controller.text.toLowerCase();
          final filtered = items.where((item) {
            final name = (item['name'] ?? '').toString().toLowerCase();
            return input.isEmpty || name.contains(input);
          }).toList();

          if (snapshot.connectionState == ConnectionState.waiting) {
            return [ListTile(title: Text('Loading...'))];
          }
          if (snapshot.hasError) {
            return [ListTile(title: Text('Error: ${snapshot.error}'))];
          }
          if (!snapshot.hasData || items.isEmpty) {
            return [ListTile(title: Text('No items found'))];
          }
          if (filtered.isEmpty) {
            return [ListTile(title: Text('No matches'))];
          }
          return filtered.map((item) {
            return ListTile(
              title: Text(item['name'] ?? 'No name'),
              subtitle: Text(item['location'] ?? 'No location'),
              onTap: () {
                Navigator.pushNamed(
                  context,
                  AppRouter.mobileproduct,
                  arguments: item,
                );
              },
            );
          }).toList();
        },
      ),
    );
  }

  Widget buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {
            print(isConnected);
          },
          icon: Icon(Icons.notifications_outlined, size: 30),
        ),
        isConnected
            ? Text(
                "Discover",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              )
            : Shimmer.fromColors(
                baseColor: Colors.grey.shade400,
                highlightColor: Colors.grey.shade200,
                child: Text(
                  "Discover",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
              ),
        IconButton(
          onPressed: () {},
          icon: Icon(FeatherIcons.messageCircle, size: 30),
        ),
      ],
    );
  }

  Widget buildStreamAds(Stream<QuerySnapshot<Object?>> adsList) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = (screenWidth < 600)
        ? screenWidth * 0.9
        : screenWidth * 0.5;
    return StreamBuilder(
      stream: adsList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade400,
            child: Container(
              height: 200,
              width: containerWidth,
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No ads found"));
        }
        final ads = snapshot.data!.docs;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: ads.length,
          itemBuilder: (context, index) {
            final ad = ads[index];
            return buildAdCard(ad);
          },
        );
      },
    );
  }

  Widget buildAdCard(QueryDocumentSnapshot<Object?> ad) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = (screenWidth < 600)
        ? screenWidth * 0.9
        : screenWidth * 0.5;
    return Card(
      margin: EdgeInsets.all(8),
      child: Container(
        width: containerWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: containerWidth * 0.5,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: 20,
                  children: [
                    Text(
                      ad['header'] ?? 'Ad Header',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      ad['subtext'] ?? 'Ad Header',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Image.network(
              ad['imageUrl'],
              width: containerWidth * 0.4,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Icon(
                  Icons.image_not_supported_outlined,
                  color: Colors.grey,
                  size: containerWidth * 0.4,
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) {
                  return child;
                } else {
                  return LoadingScreen(color: Colors.black);
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildStreamList(
    List<String> categories,
    Stream<QuerySnapshot<Object?>> itemList,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: categories.map((cat) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 6.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    cat,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRouter.mobilecategory,
                        arguments: cat,
                      );
                    },
                    child: Text(
                      "View All",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 320,
              child: StreamBuilder(
                stream: itemList,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5, // number of placeholders
                      itemBuilder: (context, index) => buildShimmerCard(),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text("Error: ${snapshot.error}"));
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(child: Text("No items found"));
                  }
                  // Filter items by category
                  final items = cat == "All"
                      ? snapshot.data!.docs
                      : snapshot.data!.docs.where((item) {
                          final itemCat = (item['category'] ?? '').toString();
                          return itemCat.toLowerCase() == cat.toLowerCase();
                        }).toList();

                  if (items.isEmpty) {
                    return Center(child: Text("No items in $cat"));
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ProductCard(item: item);
                    },
                  );
                },
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget buildShimmerCard() {
    return Container(
      width: 220,
      height: 300,
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade300,
                  highlightColor: Colors.grey.shade400,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade100,
                  highlightColor: Colors.grey.shade200,
                  child: Container(
                    height: 16,
                    width: double.infinity,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 4),
                Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade300,
                  child: Container(height: 16, width: 80, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
