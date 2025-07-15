import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteData {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  Future<void> addToFav(
    String userId,
    QueryDocumentSnapshot productData,
  ) async {
    final favRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Favorites')
        .doc(productData['productId']); // Use productId as document ID

    // Check if document exists (optional)
    final docSnapshot = await favRef.get();

    if (docSnapshot.exists) {
      // Update existing document if needed
      await favRef.update({
        'saveTime': FieldValue.serverTimestamp(),
        'isFavorite': true,
        // You can also update other fields if necessary
      });
    } else {
      // Create new document with productId as ID
      await favRef.set({
        'category': productData['category'],
        'createdAt': productData['createdAt'],
        'imageUrl': productData['imageUrl'],
        'location': productData['location'],
        'name': productData['name'],
        'ownerId': productData['ownerId'],
        'price': productData['price'],
        'description': productData['description'],
        'productId': productData['productId'],
        'saveTime': FieldValue.serverTimestamp(),
        'isFavorite': true,
      });
    }
  }

  // Fetching favorite data
  Future<bool> getFavoriteStatus(String userId, String itemId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Favorites')
        .doc(itemId)
        .get();

    if (doc.exists && doc.data() != null) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return data['isFavorite'] ??
          false; // default to false if field is missing
    }
    return false;
  }

  Future<void> updateCartItemQuantity(
    String userId,
    String productId,
    int newQuantity,
  ) async {
    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Favorites');

    // Find the document with the matching productId
    final querySnapshot = await cartRef
        .where('productId', isEqualTo: productId)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      final docId = querySnapshot.docs.first.id;

      // Update the quantity
      await cartRef.doc(docId).update({'customerQuantity': newQuantity});
    } else {
      // Handle the case where the item isn't found, if necessary
      print('Item with productId $productId not found in cart.');
    }
  }

  Future<void> removeFromFav(String userId, String productId) async {
    final cartRef = FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('Favorites');

    final docSnapshot = await cartRef
        .where('productId', isEqualTo: productId)
        .get();

    if (docSnapshot.docs.isNotEmpty) {
      await cartRef.doc(docSnapshot.docs.first.id).delete();
    }
  }

  Stream<QuerySnapshot> readFav(String uid) {
    return _db.collection("users").doc(uid).collection("Favorites").snapshots();
  }
}
