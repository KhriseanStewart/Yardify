import 'package:flutter/material.dart';
import 'package:zellyshop/components/product_row_card.dart';
import 'package:zellyshop/screen/fav/fav_manager.dart';
import 'package:zellyshop/widget/appRoutes.dart';
import 'package:zellyshop/widget/misc.dart';

class Favourites extends StatefulWidget {
  const Favourites({super.key});

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {
  @override
  Widget build(BuildContext context) {
    final favorites = FavoritesManager().favorites;
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorites"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              print(favorites);
            },
            icon: Icon(Icons.abc),
          ),
        ],
      ),
      body:
          favorites.isEmpty
              ? Center(child: Text("No favorites yet"))
              : ListView.builder(
                itemCount: favorites.length,
                itemBuilder: (context, index) {
                  final item = favorites[index];
                  // final price = int.parse(item['price']);
                  bool isFavorited = FavoritesManager().isFavorite(item);
                  void removeProduct() {
                    setState(() {
                      if (isFavorited) {
                        FavoritesManager().removeFavorite(item);
                        isFavorited = false;
                        displaySnackBar(
                          context,
                          "${item['itemName']} is removed from Favorites",
                        );
                      } else {
                        displaySnackBar(
                          context,
                          "Error removing ${item['itemName']} from Favorites",
                        );
                      }
                    });
                  }

                  return Dismissible(
                    key: UniqueKey(),
                    background: Container(color: Colors.redAccent),
                    secondaryBackground: Container(color: Colors.redAccent),
                    onDismissed: (direction) {
                      removeProduct();
                    },
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.item,
                          arguments: item,
                        );
                      },
                      child: Productrowcard(
                        productData: item,
                        itemName: item['itemName'],
                        brandName: item['brandName'],
                        image: 'assets/products/${item['image']}',
                        price: item['price'],
                      ),
                    ),
                  );
                },
              ),
    );
  }
}
