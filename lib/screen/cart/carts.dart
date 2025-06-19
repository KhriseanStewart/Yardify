import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zellyshop/components/product_row_card.dart';
import 'package:sliding_action_button/sliding_action_button.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  @override
  Widget build(BuildContext context) {
    final List<String> categories = [
      "Flash Sales uedwnijcn eudhidasjnc duahcusco ocihsochsoi c",
      "Gadgets",
      "Appliances",
      "More",
    ];
    final SlideToActionController _squareSlidToActionController =
        SlideToActionController();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cart"),
        backgroundColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            _buildHeaderContainer(),
            Divider(thickness: 1, color: Colors.black),
            Container(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Subtotal:",
                        style: GoogleFonts.poly(
                          textStyle: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Text(
                        "\$21,000",
                        style: GoogleFonts.poly(
                          textStyle: TextStyle(fontSize: 22),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  SquareSlideToActionButton(
                    width: size.width,
                    slideToActionController: _squareSlidToActionController,
                    parentBoxRadiusValue: 15,
                    squareSlidingButtonSize: 48,
                    leftEdgeSpacing: 10,
                    rightEdgeSpacing: 40,
                    initialSlidingActionLabel: 'Add To Basket',
                    finalSlidingActionLabel: 'Added To Basket',
                    squareSlidingButtonIcon: const Icon(
                      Icons.add_shopping_cart,
                      color: Colors.orange,
                    ),
                    parentBoxBackgroundColor: Colors.orange,
                    parentBoxDisableBackgroundColor: Colors.grey,
                    squareSlidingButtonBackgroundColor: Colors.white,
                    isEnable: true,
                    slideActionButtonType:
                        SlideActionButtonType.slideActionWithLoaderButton,
                    onSlideActionCompleted: () {
                      print("Complted");
                    },
                    onSlideActionCanceled: () {
                      print("Sliding action cancelled");
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  final cate = categories[index];
                  return null;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container _buildHeaderContainer() {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Khrisean Stewart",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text("Good Morning!", style: TextStyle(fontSize: 15)),
            ],
          ),
          Row(
            children: [
              Icon(Icons.location_on_outlined, size: 38),
              SizedBox(width: 2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "St.Elizabeth",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  Text("Junction"),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
