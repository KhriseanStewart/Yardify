import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yardify/mobile/database/check_internet.dart';
import 'package:yardify/mobile/database/item_list.dart';
import 'package:yardify/mobile/database/notification_service.dart';
import 'package:yardify/mobile/screens/messaging/messaging_screen.dart';
import 'package:yardify/mobile/screens/product/dis_product_card.dart';
import 'package:yardify/routes.dart';
import 'package:yardify/widgets/constant.dart';
import 'package:yardify/widgets/loading.dart';
import 'package:yardify/widgets/snack_bar.dart';

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
  final ValueNotifier<bool> _isScrolledNotifier = ValueNotifier<bool>(false);
  final ScrollController _scrollController = ScrollController();
  bool isScroll = false;

  void setisScroll() {
    setState(() {
      isScroll = _isScrolledNotifier as bool;
    });
  }

  @override
  void initState() {
    super.initState();
    NotificationService().pushToken(auth.currentUser!.uid);
    NotificationService().firebaseMessaging(context);
    _scrollController.addListener(() {
      final bool isScrolledNow = _scrollController.offset > 50;
      if (isScrolledNow != _isScrolledNotifier.value) {
        _isScrolledNotifier.value = isScrolledNow;
      }
    });
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
    _scrollController.dispose();
    _isScrolledNotifier.dispose();
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
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                ValueListenableBuilder(
                  valueListenable: _isScrolledNotifier,
                  builder: (context, value, child) {
                    final double targetHeight = value
                        ? 80.0
                        : 140.0; // Adjust your heights
                    return AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      child: SliverAppBar(
                        leading: Container(),
                        backgroundColor: Colors.white,
                        toolbarHeight: targetHeight,
                        pinned: true,
                        expandedHeight: targetHeight,
                        flexibleSpace: FlexibleSpaceBar(
                          background: ValueListenableBuilder<bool>(
                            valueListenable: _isScrolledNotifier,
                            builder: (context, isScrolled, _) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                ),
                                child: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 200),
                                  transitionBuilder: (child, animation) {
                                    return FadeTransition(
                                      opacity: animation,
                                      child: SizeTransition(
                                        sizeFactor: animation,
                                        axis: Axis.horizontal,
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: isScrolled
                                      ? // Smaller header with "Discover" and search bar side by side
                                        _buildCompactHeader(items, snapshot)
                                      : // Full header with icons, "Discover" text, and search bar below
                                        _buildFullHeader(items, snapshot),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
                // Ads
                SliverToBoxAdapter(
                  child: SizedBox(height: 220, child: buildStreamAds(adsList)),
                ),
                // Categories list
                SliverToBoxAdapter(
                  child: buildStreamList(categories, itemList),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Full header: icons + "Discover" + search bar below
  Widget _buildFullHeader(items, snapshot) {
    return Container(
      key: ValueKey('fullHeader'),
      height: 140,
      child: Column(
        children: [
          // Header with icons and "Discover" text
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  print(isConnected);
                  displaySnackBar(context, "Coming soon");
                },
                icon: Icon(
                  Icons.notifications_outlined,
                  size: 30,
                  color: Colors.black,
                ),
              ),
              isConnected
                  ? Text(
                      "Discover",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : Shimmer.fromColors(
                      baseColor: Colors.grey.shade400,
                      highlightColor: Colors.grey.shade200,
                      child: Text(
                        "Discover",
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MessagingScreen()),
                  );
                },
                icon: Icon(FeatherIcons.messageCircle, size: 30),
              ),
            ],
          ),
          // Search bar below icons
          SizedBox(height: 70, child: buildSearchBar(items, snapshot)),
        ],
      ),
    );
  }

  // Compact header: "Discover" and search bar side by side
  Widget _buildCompactHeader(items, snapshot) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: SizedBox(height: 70, child: buildSearchBar(items, snapshot)),
        ),
        Expanded(
          child: Row(
            children: [
              IconButton(
                onPressed: () {
                  print(isConnected);
                  displaySnackBar(context, "Coming soon");
                },
                icon: Icon(
                  Icons.notifications_outlined,
                  size: 30,
                  color: Colors.black,
                ),
              ),
              IconButton(
                onPressed: () {
                  displaySnackBar(context, "Coming soon");
                },
                icon: Icon(FeatherIcons.messageCircle, size: 30),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSearchBar(
    List<QueryDocumentSnapshot<Object?>> items,
    AsyncSnapshot<QuerySnapshot<Object?>> snapshot,
  ) {
    return SizedBox(
      height: 80,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(width: 0.3),
        ),
        child: SearchAnchor.bar(
          barElevation: WidgetStatePropertyAll(0),
          barBackgroundColor: WidgetStatePropertyAll(
            Theme.of(context).primaryColor,
          ),
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
      ),
    );
  }

  Widget buildHeader() {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () {
              print(isConnected);
              displaySnackBar(context, "Coming soon");
            },
            icon: Icon(Icons.notifications_outlined, size: 30),
          ),
          Opacity(
            opacity: isScroll ? 1 : 0.5,
            child: isConnected
                ? Text(
                    "Discover",
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  )
                : Shimmer.fromColors(
                    baseColor: Colors.grey.shade400,
                    highlightColor: Colors.grey.shade200,
                    child: Text(
                      "Discover",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
          IconButton(
            onPressed: () {
              displaySnackBar(context, "Coming soon");
            },
            icon: Icon(FeatherIcons.messageCircle, size: 30),
          ),
        ],
      ),
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
          color: Theme.of(context).primaryColor,
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).shadowColor,
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
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                    Text(
                      ad['subtext'] ?? 'Ad Header',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 16,
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CachedNetworkImage(
              imageUrl: ad['imageUrl'] ?? "Ad Header",
              fit: BoxFit.cover,
              width: containerWidth * 0.4,
              errorWidget: (context, url, error) {
                return Icon(Icons.image_not_supported_outlined, size: 20);
              },
              progressIndicatorBuilder: (context, url, progress) {
                return Image.network(
                  url,
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
                );
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
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColorLight,
                    ),
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
                        color: Theme.of(context).primaryColorLight,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 260,
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
                    SizedBox;
                  }
                  // Filter items by category
                  final items = cat == "All"
                      ? snapshot.data!.docs
                      : snapshot.data!.docs.where((item) {
                          final itemCat = (item['category'] ?? '').toString();
                          return itemCat.toLowerCase() == cat.toLowerCase();
                        }).toList();

                  if (items.isEmpty) {
                    return SizedBox();
                  }

                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return ProductCard(item: item, variant: 'dis');
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
