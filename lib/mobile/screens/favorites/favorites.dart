import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yardify/mobile/auth/authCheck/auth_service.dart';
import 'package:yardify/mobile/database/item_list.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    String uid = AuthService().currentUser!.uid;
    final fav = ProductService().getFav(uid);

    return Scaffold(
      appBar: AppBar(title: Text("Favorites"), centerTitle: true),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: fav,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text("No items found"));
                }
                final favProduct = snapshot.data!.docs;

                return ListView.builder(
                  itemCount: favProduct.length,
                  itemBuilder: (context, index) {
                    final product = favProduct[index];
                    final List<dynamic> docRefList = product['document'];
                    final List<DocumentReference> docRefs =
                        List<DocumentReference>.from(docRefList);

                    // For each favorite item, show its documents in separate cards
                    return Column(
                      children: [
                        // Optionally, add a header or title for each favorite item
                        // Text('Favorite Item ${index + 1}', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: docRefs.length,
                          itemBuilder: (context, docIndex) {
                            final DocumentReference docRef = docRefs[docIndex];
                            return Card(
                              margin: EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: FutureBuilder<DocumentSnapshot>(
                                  future: docRef.get(),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    } else if (snapshot.hasError) {
                                      return Text('Error: ${snapshot.error}');
                                    } else if (!snapshot.hasData ||
                                        !snapshot.data!.exists) {
                                      return Text('Document not found');
                                    } else {
                                      final data =
                                          snapshot.data!.data()
                                              as Map<String, dynamic>;
                                      return Container(
                                        child: Column(
                                          children: [
                                            Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                image: DecorationImage(
                                                  image: NetworkImage(
                                                    data['imageUrl'] is List
                                                        ? (data['imageUrl']
                                                                  .isNotEmpty
                                                              ? data['imageUrl'][0]
                                                              : '')
                                                        : (data['imageUrl'] ??
                                                              ''),
                                                  ),

                                                  fit: BoxFit.cover,
                                                  onError:
                                                      (exception, stackTrace) =>
                                                          Icon(
                                                            Icons.error,
                                                            color: Colors.red,
                                                          ),
                                                ),
                                              ),
                                              child: Image.network(
                                                data['imageUrl'] is List
                                                    ? (data['imageUrl']
                                                              .isNotEmpty
                                                          ? data['imageUrl'][0]
                                                          : '')
                                                    : (data['imageUrl'] ?? ''),
                                              ),
                                            ),
                                            Row(
                                              children: [
                                                Text(data['name'] ?? 'No name'),
                                                Text(
                                                  data['location'] ?? 'No name',
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
