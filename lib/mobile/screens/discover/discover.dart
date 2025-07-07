import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:yardify/mobile/database/item_list.dart';
import 'package:yardify/mobile/screens/product/dis_product_card.dart';
import 'package:yardify/routes.dart';

class MobileDiscover extends StatefulWidget {
  const MobileDiscover({super.key});

  @override
  State<MobileDiscover> createState() => _MobileDiscoverState();
}

bool isFavorite = false;
final SearchController searchController = SearchController();

class _MobileDiscoverState extends State<MobileDiscover> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    UserService().requestPermissions();
  }
    Future<void> _refreshPage() async {
    // Implement your reload logic here, e.g., fetch data again
    // For demonstration, just wait a moment
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      // Update your data here to refresh the page
    });
  }

  @override
  Widget build(BuildContext context) {
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
          body: RefreshIndicator(
            onRefresh: _refreshPage,
            child: SafeArea(
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
          onPressed: () {},
          icon: Icon(Icons.notifications_outlined, size: 30),
        ),
        Text(
          "Discover",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, ),
        ),
        IconButton(
          onPressed: () {},
          icon: Icon(FeatherIcons.messageCircle, size: 30),
        ),
      ],
    );
  }

  Widget buildStreamAds(Stream<QuerySnapshot<Object?>> adsList) {
    return StreamBuilder(
      stream: adsList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text("No ads found"));
        }
        final ads = snapshot.data!.docs;
        final width = MediaQuery.of(context).size.width;
        return ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: ads.length,
          itemBuilder: (context, index) {
            final ad = ads[index];
            return buildAdCard(width, ad);
          },
        );
      },
    );
  }

  Widget buildAdCard(double width, QueryDocumentSnapshot<Object?> ad) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = (screenWidth <= 600 && screenWidth >= 1024)
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
                return Icon(Icons.error, color: Colors.red);
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
                    return Center(child: CircularProgressIndicator());
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
}
