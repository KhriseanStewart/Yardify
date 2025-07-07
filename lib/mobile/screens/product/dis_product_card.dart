import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yardify/routes.dart';

class ProductCard extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> item;
  const ProductCard({super.key, required this.item});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, AppRouter.mobileproduct, arguments: item);
      },
      child: Container(
        margin: EdgeInsets.all(2),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          color: Colors.white,
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
                          Icon(Icons.error, color: Colors.red),
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
                        setState(() {
                          isFavorite = !isFavorite;
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
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "JMD${item['price'] ?? ''}",
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
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
