import 'package:flutter/material.dart';
import 'package:zellyshop/screen/fav/fav_manager.dart';
import 'package:zellyshop/widget/misc.dart';

// ignore: must_be_immutable
class ProductCard extends StatefulWidget {
  final Map<String, dynamic> productData;
  final String? image;
  final String? price;
  final String? brandName;
  final String? itemName;
  final String? rating;
  bool? fav;
  ProductCard({
    super.key,
    required this.productData,
    required this.image,
    required this.price,
    required this.brandName,
    required this.itemName,
    required this.rating,
    this.fav,
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late bool isFavorited;

  @override
  void initState() {
    super.initState();
    // Initialize local favorite state based on the FavoritesManager
    isFavorited = FavoritesManager().isFavorite(widget.productData);
  }

  void addToFav() {
    setState(() {
      if (isFavorited) {
        FavoritesManager().removeFavorite(widget.productData);
        isFavorited = false;
      } else {
        FavoritesManager().addFavorite(widget.productData);
        isFavorited = true;
      }
      displaySnackBar(
        context,
        "${widget.itemName} has been ${FavoritesManager().isFavorite(widget.productData) ? 'added to' : 'removed from'} Favourites",
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isFavorited = FavoritesManager().isFavorite(widget.productData);
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  widget.image ?? 'Error',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 140,
                ),
              ),
              Positioned(
                top: 4,
                right: 8,
                child: GestureDetector(
                  onTap: addToFav,
                  child: Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    //CHATGPT ANIMATED SWITCHER
                    child: AnimatedSwitcher(
                      duration: Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) {
                        return ScaleTransition(scale: animation, child: child);
                      },
                      child: Icon(
                        isFavorited ? Icons.favorite : Icons.favorite_outline,
                        key: ValueKey<bool>(isFavorited),
                        size: 20,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ),
              ),
              // Positioned(
              //   bottom: 2,
              //   left: 2,
              //   child: Container(
              //     padding: EdgeInsets.all(4),
              //     decoration: BoxDecoration(
              //       color: Colors.white,
              //       shape: BoxShape.rectangle,
              //       borderRadius: BorderRadius.circular(6),
              //     ),
              //     child: Row(
              //       children: [
              //         Icon(
              //           Icons.star_border_purple500_rounded,
              //           size: 18,
              //           color: Colors.lightBlueAccent,
              //         ),
              //         Text(
              //           widget.rating ?? "Error",
              //           style: TextStyle(
              //             fontSize: 14,
              //             fontWeight: FontWeight.w300,
              //           ),
              //         ),
              //       ],
              //     ),
              //   ),
              // ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.itemName ?? 'Error',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "\$${widget.price ?? 'error'}",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: () {
                        displaySnackBar(context, "Add to cart coming soon");
                      },
                      child: Container(
                        padding: EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          shape: BoxShape.rectangle,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        //CHATGPT ANIMATED SWITCHER
                        child: AnimatedSwitcher(
                          duration: Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) {
                            return ScaleTransition(
                              scale: animation,
                              child: child,
                            );
                          },
                          child: Icon(Icons.add, size: 20, color: Colors.blue),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
