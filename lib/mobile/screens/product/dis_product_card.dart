import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yardify/mobile/database/favorite_data.dart';
import 'package:yardify/routes.dart';
import 'package:yardify/widgets/constant.dart';
import 'package:intl/intl.dart';
import 'package:yardify/widgets/snack_bar.dart';

class ProductCard extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> item;
  final String variant;
  const ProductCard({super.key, required this.item, required this.variant});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;
  Map<String, bool> favoriteStatusMap = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isFav();
  }

  void isFav() async {
    bool value = await FavoriteData().getFavoriteStatus(
      auth.currentUser!.uid,
      widget.item['productId'],
    );
    if (!mounted) return; // Check if widget is still in widget tree
    setState(() {
      isFavorite = value;
    });
    print("Item is $value");
  }

  @override
  Widget build(BuildContext context) {
    String productLink =
        "https://yardify-web-react.vercel.app/productpage/${widget.item['productId']}";

    void shareable() async {
      try {
        // ignore: deprecated_member_use
        final result = await Share.share(
          "Check out this item on SoByMarket $productLink",
          subject: 'Sharing a Product',
        );
        if (result.status == ShareResultStatus.success) {
          displaySnackBar(context, "Thank you for sharing my website!");
        }
      } catch (e) {
        displaySnackBar(context, "Error $e");
      }
    }

    final auth = FirebaseAuth.instance.currentUser;
    final item = widget.item;

    final firebasePrice = item['price'];
    final formatter = NumberFormat('#,###'); //single formatter for both
    final price = formatter.format(firebasePrice);

    return widget.variant != "fav"
        ? GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRouter.mobileproduct,
                arguments: item,
              );
            },
            child: Container(
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                // color: Theme.of(context).primaryColor,
              ),
              width: 220,
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          child: Image.network(
                            item['imageUrl'] is List
                                ? (item['imageUrl'].isNotEmpty
                                      ? item['imageUrl'][0]
                                      : '')
                                : (item['imageUrl'] ?? ''),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                    size: SizeConfig.widthPercentage(60),
                                  ),
                                ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade200,
                                  highlightColor: Colors.grey.shade300,
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: Colors.grey,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: IconButton(
                            icon: isFavorite
                                ? Icon(
                                    Icons.favorite,
                                    size: 30,
                                    color: Colors.redAccent,
                                  )
                                : Icon(Icons.favorite_border, size: 30),
                            onPressed: () {
                              if (isFavorite) {
                                FavoriteData().removeFromFav(
                                  auth!.uid,
                                  item['productId'],
                                );
                              }
                              setState(() {
                                isFavorite = !isFavorite;
                                FavoriteData().addToFav(auth!.uid, item);
                              });
                              // Handle favorite action
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['name'] ?? '',
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "JMD$price",
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        : GestureDetector(
            onTap: () {
              Navigator.pushNamed(
                context,
                AppRouter.mobileproduct,
                arguments: item,
              );
            },
            child: Container(
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).primaryColor,
              ),
              width: 220,
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                          ),
                          child: Image.network(
                            item['imageUrl'] is List
                                ? (item['imageUrl'].isNotEmpty
                                      ? item['imageUrl'][0]
                                      : '')
                                : (item['imageUrl'] ?? ''),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                  child: Icon(
                                    Icons.image,
                                    color: Colors.grey,
                                    size: SizeConfig.widthPercentage(60),
                                  ),
                                ),
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Shimmer.fromColors(
                                  baseColor: Colors.grey.shade200,
                                  highlightColor: Colors.grey.shade300,
                                  child: Container(
                                    width: double.infinity,
                                    height: double.infinity,
                                    color: Colors.grey,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                        Positioned(
                          top: 2,
                          right: 2,
                          child: IconButton(
                            icon: Icon(Icons.share),
                            onPressed: () {
                              shareable();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8.0,
                      vertical: 4.0,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item['name'] ?? '',
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w300,
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "JMD$price",
                          textAlign: TextAlign.start,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).primaryColorLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
