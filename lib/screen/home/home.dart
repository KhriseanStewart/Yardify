import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:zellyshop/components/product_card.dart';
import 'package:zellyshop/database/temp_db.dart';
import 'package:zellyshop/widget/appRoutes.dart';
import 'package:zellyshop/widget/misc.dart';
import 'package:feather_icons/feather_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

final SearchController _searchController = SearchController();

//CHATGPT ASSISTANCE TO FILTER PRODUCTS FROM 2 Lists
String selectedCategory = 'All Products';

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
          child: Column(
            children: [
              buildHeaderContainer(),
              SizedBox(height: 10),
              _searchAnchorBar(),
              SizedBox(height: 10),
              SizedBox(
                height: 150,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return AdsContainer();
                  },
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Category",
                    style: GoogleFonts.poly(
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              _buildCateList(categories, (category) {
                setState(() {
                  selectedCategory = category;
                });
              }),
              SizedBox(height: 20),
              _buildRecommendedList(categories),
              Row(
                children: [
                  Text(
                    "For You",
                    style: GoogleFonts.poly(
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 500,
                child: ListView.builder(
                  itemCount: productDetails.length,
                  itemBuilder: (context, index) {
                    final products = productDetails[index];
                    return FYProductCardRow(products: products);
                  },
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Popular Products",
                    style: GoogleFonts.poly(
                      textStyle: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 230,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productDetails.length,
                  itemBuilder: (context, index) {
                    final products = productDetails[index];
                    return ProductCard(
                      productData: products,
                      image: 'assets/products/${products['image']}',
                      price: products['price'],
                      brandName: products['brandName'],
                      itemName: products['itemName'],
                      rating: products['rating'],
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  SearchAnchor _searchAnchorBar() {
    return SearchAnchor.bar(
      barBackgroundColor: WidgetStatePropertyAll(Colors.grey.shade300),
      barElevation: WidgetStatePropertyAll(0),
      barHintText: "Search",
      searchController: _searchController,
      suggestionsBuilder: (context, controller) {
        final String input = controller.value.text;
        if (input.isEmpty) {
          return [];
        }
        return productDetails
            .where((product) {
              return product.toString().toLowerCase().contains(
                input.toLowerCase(),
              );
            })
            .map((product) {
              return ListTile(
                title: Text(product["itemName"]),

                onTap: () {
                  _searchController.closeView(product['itemName']);
                  Navigator.pushNamed(
                    context,
                    AppRoutes.item,
                    arguments: product,
                  );
                },
              );
            });
      },
    );
  }

  SizedBox _buildCateList(
    List<String> categories,
    Function(String) onCategorySelected,
  ) {
    return SizedBox(
      height: 34,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final cate = categories[index];
          final isSelected = cate == selectedCategory;
          return GestureDetector(
            onTap: () {
              onCategorySelected(cate);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              margin: EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color:
                    isSelected ? Colors.lightBlueAccent : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(cate, style: TextStyle(fontSize: 14)),
            ),
          );
        },
      ),
    );
  }

  SizedBox _buildRecommendedList(List<String> categories) {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: filteredProducts.length,
        itemBuilder: (context, index) {
          final products = filteredProducts[index];
          // final price = int.parse(products['price']);
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, AppRoutes.item, arguments: products);
            },
            child: ProductCard(
              productData: products,
              image: 'assets/products/${products['image']}',
              price: products['price'],
              brandName: products['brandName'],
              itemName: products['itemName'],
              rating: products['rating'],
            ),
          );
        },
      ),
    );
  }
}

class AdsContainer extends StatelessWidget {
  const AdsContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          image: AssetImage('assets/products/xr-5c.jpg'),
          fit: BoxFit.cover,
        ),
      ),
      margin: EdgeInsets.only(right: 10),
      width: 300,
      height: 150,
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "New Iphone XR",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "In stock at Zelly shop",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w300,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    backgroundColor: Colors.black,
                  ),
                  child: Text("Buy now", style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
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
      height: 140,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        spacing: 10,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                "assets/products/${products['image']}",
                fit: BoxFit.cover,
                width: double.infinity,
                height: 140,
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

// ignore: camel_case_types
class buildHeaderContainer extends StatelessWidget {
  const buildHeaderContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ClipRRect(child: Text("User Profile")),
            Text(
              "Discover",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
            ),
          ],
        ),
        Row(
          spacing: 10,
          children: [
            GestureDetector(
              onTap: () {
                displaySnackBar(context, "Coming soon");
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(FeatherIcons.messageCircle, size: 28),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
              child: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  shape: BoxShape.circle,
                ),
                child: Icon(FeatherIcons.logOut, size: 28),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
