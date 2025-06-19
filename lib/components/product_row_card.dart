import 'package:flutter/material.dart';
import 'package:zellyshop/screen/fav/fav_manager.dart';
import 'package:zellyshop/widget/misc.dart';

class Productrowcard extends StatefulWidget {
  final Map<String, dynamic> productData;
  final String? image;
  final String? price;
  final String? brandName;
  final String? itemName;
  const Productrowcard({
    super.key,
    required this.productData,
    this.image,
    this.price,
    this.brandName,
    this.itemName,
  });

  @override
  State<Productrowcard> createState() => _ProductrowcardState();
}

class _ProductrowcardState extends State<Productrowcard> {
  bool _checkBox = false;
  late bool isFavorited;

  @override
  void initState() {
    super.initState();
    isFavorited = FavoritesManager().isFavorite(widget.productData);
  }

  void removeProduct() {
    setState(() {
      if (isFavorited) {
        FavoritesManager().removeFavorite(widget.productData);
        isFavorited = false;
        displaySnackBar(
          context,
          "${widget.itemName} is removed from Favorites",
        );
      } else {
        displaySnackBar(
          context,
          "Error removing ${widget.itemName} from Favorites",
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //FAILSAFE CHECK
    if (widget.image == null ||
        widget.price == null ||
        widget.brandName == null ||
        widget.itemName == null) {
      return const Center(child: Text('Error: Missing product data'));
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.white,
      ),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      margin: EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Checkbox(
                value: _checkBox,
                onChanged: (value) {
                  setState(() {
                    _checkBox = !_checkBox;
                  });
                  print(_checkBox);
                },
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image(
                  image: AssetImage(widget.image ?? 'error'),
                  fit: BoxFit.cover,
                  height: 90,
                  width: 90,
                ),
              ),
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.itemName ?? "ITEM NAME",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  widget.brandName ?? "Brand Name",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Text(
                  "\$${widget.price ?? 0}",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          //can add something here
        ],
      ),
    );
  }
}

class FYProductCardRow extends StatelessWidget {
  const FYProductCardRow({super.key, required this.products});

  final Map<String, dynamic> products;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        border: Border.all(color: Colors.grey.shade200, width: 2),
        borderRadius: BorderRadius.circular(14),
      ),
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
      margin: EdgeInsets.only(bottom: 6),
      child: Row(
        spacing: 10,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/products/${products['image']}",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 100,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  products['itemName'],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
                Text(
                  "\$${products['price']}",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.lightBlueAccent),
                    Text(products['rating']),
                    SizedBox(width: 4),
                    Text(
                      "(117 reviews)",
                      style: TextStyle(fontWeight: FontWeight.w300),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 40, child: Icon(Icons.arrow_forward_ios_outlined)),
        ],
      ),
    );
  }
}