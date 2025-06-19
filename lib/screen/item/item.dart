import 'package:flutter/material.dart';
import 'package:zellyshop/screen/fav/fav_manager.dart';
import 'package:zellyshop/widget/appRoutes.dart';
import 'package:zellyshop/widget/custom_btn_v2.dart';
import 'package:zellyshop/widget/expand_text.dart';
import 'package:zellyshop/widget/misc.dart';
import 'package:feather_icons/feather_icons.dart';

class ProductItem extends StatefulWidget {
  const ProductItem({super.key});

  @override
  State<ProductItem> createState() => _ProductItemState();
}

int count = 1;
int selectedIndex = 0;

class _ProductItemState extends State<ProductItem> {
  void onAdd() {
    setState(() {
      count += 1;
    });
  }

  void onMinus() {
    setState(() {
      count -= 1;
    });
  }

  void onTapBuy() {
    displaySnackBar(context, "Buy page currently down");
  }

  void onTapCart() {
    displaySnackBar(context, "Cart page currently down");
  }

  void onTapOffer() {
    displaySnackBar(context, "Place an offer");
  }

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;

    bool isFavorite = FavoritesManager().isFavorite(args);

    void addToFav() {
      setState(() {
        if (isFavorite) {
          FavoritesManager().removeFavorite(args);
          isFavorite = false;
        } else {
          FavoritesManager().addFavorite(args);
          isFavorite = true;
        }
        displaySnackBar(
          context,
          "${args['itemName']} has been ${FavoritesManager().isFavorite(args) ? 'added to' : 'removed from'} Favourites",
        );
      });
    }

    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(args['itemName'].toString().toUpperCase()),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, AppRoutes.cart);
            },
            icon: Icon(FeatherIcons.shoppingBag),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset('assets/products/${args['image']}'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 10.0,
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            args['itemName'],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 30,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "\$${args['price']}",
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              AddMinusMethod(),
                            ],
                          ),
                          SizedBox(height: 6),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ItemRowStuff(
                                args: args,
                                icon: Icon(Icons.star, color: Colors.blue),
                                ratings: args['rating'],
                                reviews: '117 reviews',
                              ),
                              ItemRowStuff(
                                ontap: () {
                                  addToFav();
                                  //TODO Make sure to add a fail safe
                                },
                                args: args,
                                icon: AnimatedSwitcher(
                                  duration: Duration(milliseconds: 300),
                                  transitionBuilder: (child, animation) {
                                    return ScaleTransition(
                                      scale: animation,
                                      child: child,
                                    );
                                  },
                                  child: Icon(
                                    isFavorite
                                        ? Icons.favorite
                                        : Icons.favorite_outline,
                                    key: ValueKey<bool>(isFavorite),
                                    color: Colors.blue,
                                  ),
                                ),
                                ratings: '17',
                              ),
                              ItemRowStuff(
                                args: args,
                                icon: Icon(Icons.message, color: Colors.blue),
                                ratings: '17',
                              ),
                              ItemRowStuff(
                                args: args,
                                ratings: '',
                                icon: Icon(Icons.share),
                              ),
                            ],
                          ),
                          SizedBox(height: 6),
                          Divider(thickness: 1),
                          SizedBox(height: 5),
                          SizedBox(
                            height: 150,
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Description",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  ExpandableText(
                                    text:
                                        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Divider(thickness: 1),
                          SizedBox(height: 6),
                          Text(
                            "Seller Details",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          ItemUserContainer(),
                          SizedBox(height: 5),
                          Divider(thickness: 1),
                          SizedBox(height: 8),
                          Text(
                            "Meetup Preferences",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: MeetUpDetails(),
                          ),
                          SizedBox(height: 8),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                "Non Provided",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Divider(thickness: 1),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              decoration: BoxDecoration(color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12.0,
                  vertical: 14.0,
                ),
                child: BottomBuyButtons(size),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Column MeetUpDetails() {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.public),
            SizedBox(width: 4),
            Text(
              "Public Location",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.sensor_door),
            SizedBox(width: 4),
            Text(
              "Door Pickup",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.directions_transit_filled_rounded),
            SizedBox(width: 4),
            Text(
              "Transfer",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 8),
      ],
    );
  }

  Row BottomBuyButtons(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 10,
      children: [
        GestureDetector(
          onTap: () {
            onTapOffer();
          },
          child: Tooltip(
            message: 'Place Offer',
            child: Container(
              height: 50,
              width: size.width / 8,
              padding: EdgeInsets.all(6),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400, width: 2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.attach_money_rounded, size: 30),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: CustomBtnV2(
            onpress: () {
              onTapBuy();
            },
            btntext: 'Buy now',
            isBoldtext: true,
            size: 16,
            textcolor: Colors.white,
            bgcolor: Colors.lightBlue.shade400,
          ),
        ),
        // Expanded(
        //   flex: 2,
        //   child: CustomBtnV2(
        //     onpress: () {
        //       onTapCart();
        //     },
        //     btntext: 'Add to cart',
        //     isBoldtext: true,
        //     size: 16,
        //     textcolor: Colors.white,
        //     bgcolor: Colors.lightBlue.shade400,
        //   ),
        // ),
      ],
    );
  }

  Container AddMinusMethod() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: () {
              onAdd();
            },
            icon: Icon(Icons.add),
          ),
          Text(count.toString()),
          IconButton(
            onPressed: () {
              onMinus();
            },
            icon: Icon(Icons.remove),
          ),
        ],
      ),
    );
  }
}

class ItemRowStuff extends StatelessWidget {
  final Map args;
  final String ratings;
  final VoidCallback? ontap;
  final Widget icon;
  final String? reviews;
  const ItemRowStuff({
    super.key,
    required this.args,
    required this.ratings,
    required this.icon,
    this.ontap,
    this.reviews,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.lightBlueAccent, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            icon,
            SizedBox(width: 2),
            Text(
              ratings,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            SizedBox(width: 6),
            Text(reviews ?? '', style: TextStyle(fontWeight: FontWeight.w400)),
          ],
        ),
      ),
    );
  }
}

class ItemUserContainer extends StatelessWidget {
  const ItemUserContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(color: Colors.grey),
                  child: Icon(Icons.person, size: 38),
                ),
              ),
              SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Budget Rigs JA",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 17),
                  ),
                  Text(
                    "Not Verified",
                    style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          IconButton(
            onPressed: () {
              displaySnackBar(context, "You followed USER!");
            },
            tooltip: 'Follow',
            icon: Icon(Icons.add),
          ),
        ],
      ),
    );
  }
}
