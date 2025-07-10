import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ProfileRow extends StatefulWidget {
  final String productId; // pass the product ID

  const ProfileRow({required this.productId, Key? key}) : super(key: key);

  @override
  _ProfileRowState createState() => _ProfileRowState();
}

class _ProfileRowState extends State<ProfileRow> {
  late Future<DocumentSnapshot> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = FirebaseFirestore.instance
        .collection('products')
        .doc(widget.productId)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: _productFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || !snapshot.data!.exists) {
          return Center(child: Text('Product not found'));
        }

        final productData = snapshot.data!.data() as Map<String, dynamic>;
        final userUID = productData['ownerId'];

        // Now fetch the user data
        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .doc(userUID)
              .get(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (userSnapshot.hasError) {
              String message;
              final error = snapshot.error;
              if (error is FirebaseException) {
                message = "${error.message}";
              } else {
                message = 'Unexpected Error';
              }
              return Center(child: Text('Error: $message'));
            }
            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
              return Center(child: Text('User not found'));
            }

            final userData = userSnapshot.data!.data() as Map<String, dynamic>;
            final name = userData['name'];
            final tnumber = userData['telephone'];

            return Container(
              margin: EdgeInsets.symmetric(horizontal: 3.0),
              padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 8.0),
              decoration: BoxDecoration(
                color: Colors.transparent,
                borderRadius: BorderRadius.circular(10),
              ),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name ?? 'Unknown',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            tnumber?.toString() ?? 'N/A',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  MaterialButton(
                    color: Colors.grey.shade300,
                    onPressed: () {},
                    child: Text(
                      "Follow",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
