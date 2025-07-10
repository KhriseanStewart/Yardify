import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:yardify/mobile/auth/authCheck/auth_service.dart';
import 'package:yardify/mobile/screens/profile/ps_profile_card.dart';
import 'package:share_plus/share_plus.dart';
import 'package:yardify/routes.dart';
import 'package:yardify/widgets/constant.dart';
import 'package:yardify/widgets/custom_button.dart';
import 'package:yardify/widgets/snack_bar.dart';

class ProductScreen extends StatefulWidget {
  final AuthService auth;
  const ProductScreen({super.key, required this.auth});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

late PageController _pageController;
double _currentPage = 0;

class _ProductScreenState extends State<ProductScreen> {
  @override
  void initState() {
    super.initState();
    _currentPage = 0;
    _pageController = PageController();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    final product =
        ModalRoute.of(context)!.settings.arguments as QueryDocumentSnapshot;

    final dynamic imageUrlField = product['imageUrl'];
    print(imageUrlField);

    List<String> productImages;

    if (imageUrlField is List) {
      // It's a list, ensure all elements are strings
      productImages = List<String>.from(imageUrlField);
    } else if (imageUrlField is String) {
      // It's a single string, make it a list
      productImages = [imageUrlField];
      print(imageUrlField);
    } else {
      // Fallback: empty list or handle error
      productImages = [];
    }
    String productLink =
        "https://yardify-web-react.vercel.app/productpage/${product.id}";

    void shareable() async {
      try {
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

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRouter.mainlayout);
          },
          icon: Icon(Icons.close),
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(FeatherIcons.search)),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      height: SizeConfig.heightPercentage(45),
                      child: PageView.builder(
                        controller: _pageController,
                        //Fix soon
                        itemCount: productImages.length,
                        itemBuilder: (context, index) {
                          final scale = (1 - (_currentPage - index))
                              .abs()
                              .clamp(0.8, 1.0);
                          return Transform.scale(
                            scale: scale,
                            child: SizedBox(
                              width: double.infinity,
                              child: Image.network(
                                productImages[index],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Icon(
                                    Icons.image_not_supported_outlined,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: Colors.transparent,
                        ),
                        icon: Icon(Icons.share_rounded, size: 24),
                        onPressed: () {
                          shareable();
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      right: 0,
                      left: 0,
                      child: buildDots(productImages),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    spacing: 6,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "JMD ${product['price']}",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Row(
                        spacing: 4,
                        children: [
                          Icon(Icons.location_on_outlined),
                          Text(
                            product['location'],
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                ProfileRow(productId: product.id),
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(height: 60),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8.0,
                vertical: 6.0,
              ),
              child: Row(
                spacing: 8,
                children: [
                  Expanded(
                    child: CustomButton(
                      btntext: "Message Seller",
                      bgcolor: Colors.white,
                      textcolor: Colors.black,
                      isBoldtext: true,
                      size: 18,
                      borderRadius: 8,
                    ),
                  ),
                  Tooltip(
                    message: "Place an Offer",
                    child: GestureDetector(
                      onTap: () {
                        //handle Offer Placement
                      },
                      child: Container(
                        height: 50,
                        width: 50,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey.shade400),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(Icons.attach_money_rounded),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDots(productImages) {
    return Padding(
      padding: EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(productImages.length, (index) {
          bool isActive =
              index == _currentPage.round(); // Use round for proper matching
          return AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.symmetric(horizontal: 4),
            width: isActive ? 22 : 8,
            height: isActive ? 12 : 8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isActive ? Colors.black : Colors.grey,
            ),
          );
        }),
      ),
    );
  }
}
