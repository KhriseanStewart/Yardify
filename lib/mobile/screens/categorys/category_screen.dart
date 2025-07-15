import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yardify/mobile/database/item_list.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as String;
    final cat = args;
    final itemList = ProductService().getItems();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(cat),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Expanded(child: buildStreamCategory(itemList, cat)),
          ],
        ),
      ),
    );
  }

  Widget buildStreamCategory(
    Stream<QuerySnapshot<Object?>> itemList,
    String cat,
  ) {
    return StreamBuilder(
      stream: itemList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: Theme.of(context).primaryColorLight,));
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No items found in this category.'));
        }
        final items = cat == "All"
            ? snapshot.data!.docs
            : snapshot.data!.docs.where((item) {
                final itemCat = (item['category'] ?? '').toString();
                return itemCat.toLowerCase() == cat.toLowerCase();
              }).toList();
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.7, // Adjust as needed for your content
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            return items.isNotEmpty
                ? buildProductCard(item)
                : Center(child: Text('No items found in this category.'));
          },
        );
      },
    );
  }

  Widget buildProductCard(QueryDocumentSnapshot<Object?> item) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Use AspectRatio to constrain image
          AspectRatio(
            aspectRatio: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(4)),
              child: Image.network(
                item['imageUrl'] is List
                    ? (item['imageUrl'].isNotEmpty ? item['imageUrl'][0] : '')
                    : (item['imageUrl'] ?? ''),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.image_not_supported, size: 48),
              ),
            ),
          ),
          SizedBox(height: 4.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              item['name'] ?? 'No Name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              item['location'] ?? 'No Location',
              style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '\$${item['price'] ?? '0'}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
