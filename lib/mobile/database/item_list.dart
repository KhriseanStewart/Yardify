import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';
import 'package:yardify/routes.dart';

var uuid = Uuid();
final FirebaseStorage _storage = FirebaseStorage.instance;

class ProductService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Get Items as Stream
  Stream<QuerySnapshot> getItems() {
    return _db.collection("products").snapshots();
  }

  // Get Items as Stream
  Stream<QuerySnapshot> getAds() {
    return _db.collection("ads").snapshots();
  }

  // Get Items as Stream
  Stream<QuerySnapshot> getFav(String uid) {
    return _db.collection("favorites").where('uid', isEqualTo: uid).snapshots();
  }

  Future<void> logout() {
    final signout = FirebaseAuth.instance.signOut();
    return signout;
  }
}

class UserService {
  final _user = FirebaseAuth.instance.currentUser;
  final FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addUser(
    String name,
    String userName,
    String email,
    int telephone,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    } else {
      await db.collection("users").doc(user.uid).set({
        "name": name,
        "username": userName,
        "email": email,
        "telephone": telephone.toString(),
        "timestamp": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  Future<void> updateProfilePic(String userId, String newImageUrl) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).set({
      'profilePic': newImageUrl,
    }, SetOptions(merge: true));
  }

  Future<bool> requestPermissions() async {
    Permission.camera.request();
    Permission.manageExternalStorage.request();
    final statusCamera = await Permission.camera.status;
    final statusStorage = await Permission.manageExternalStorage.status;

    if (!statusCamera.isGranted || !statusStorage.isGranted) {
      print(statusCamera);
      print(statusStorage);
      return false;
    }
    return true;
  }

  Future<String?> addProfilePic() async {
    final ImagePicker _picker = ImagePicker();

    // Check permissions
    final statusCamera = await Permission.camera.status;
    final statusStorage = await Permission.manageExternalStorage.status;
    requestPermissions();

    print(statusCamera);
    print(statusStorage);
    if (statusCamera.isGranted && statusStorage.isGranted) {
      final imagePicked = await _picker.pickImage(source: ImageSource.gallery);
      if (imagePicked != null) {
        // Upload image and get URL
        String downloadUrl = await uploadImageAndGetUrl(imagePicked);
        return downloadUrl;
      }
    }
    return null; // Return null if no image selected or permissions denied
  }

  // Helper method to upload image and get the download URL
  Future<String> uploadImageAndGetUrl(XFile image) async {
    Reference ref = _storage.ref('profiles/user/${_user!.uid}/${_user.uid}');
    try {
      UploadTask uploadTask = ref.putFile(File(image.path));
      TaskSnapshot snapshot = await uploadTask;

      String downloadUrl = await snapshot.ref.getDownloadURL();
      await updateProfilePic(_user.uid, downloadUrl);
      return downloadUrl;
    } catch (e) {
      print('Upload error: $e');
      rethrow;
    }
  }

  Future<Widget> loadProfileImage(uid) async {
    String imageUrl = await loadAndDisplayImage(uid);

    auth.currentUser!.updatePhotoURL(imageUrl);
    if (imageUrl != null && imageUrl.isNotEmpty) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error_outline_outlined);
        },
      );
    } else {
      return Icon(Icons.person);
    }
  }

  Future<String> loadAndDisplayImage(uid) async {
    // Fetch user document from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users') // your collection name
        .doc(uid)
        .get();

    if (userDoc.exists && userDoc['profilePic'] != null) {
      String imageUrl = userDoc['profilePic'];
      return imageUrl;
    } else {
      String imageUrl = '';
      return imageUrl;
    }
  }
}

class UploadDocument {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Add Item
  Future<void> addListing(
    String category,
    String imagePath,
    String location,
    String name,
    String price,
    String description,
  ) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final String productId = uuid.v4();
    String imageUrl = await uploadImageAndGetUrl(imagePath, productId);

    await _db.collection('products').doc(productId).set({
      "category": category,
      "createdAt": FieldValue.serverTimestamp(),
      "imageUrl": imageUrl,
      "location": location,
      "name": name,
      "ownerId": user.uid,
      "price": price,
      "description": description,
    });
  }

  // Helper method to upload image and get the download URL
  Future<String> uploadImageAndGetUrl(
    String imagePath,
    String productId,
  ) async {
    final File file = File(imagePath);
    String fileName = basename(imagePath);
    Reference ref = _storage.ref('products/$productId/$fileName');

    try {
      UploadTask uploadTask = ref.putFile(file);
      TaskSnapshot snapshot = await uploadTask;
      return await snapshot.ref.getDownloadURL();
    } catch (e) {
      print('Upload error: $e');
      rethrow;
    }
  }

  // Delete item
  Future<void> deleteListing(String docId) async {
    await _db.collection('products').doc(docId).snapshots();
  }
}

List<String> categories = [
  "All",
  "Electronics",
  "Vehicles",
  "Property for Sale",
  "Property for Rent",
  "Home Appliances",
  "Furniture",
  "Clothing & Accessories",
  "Baby & Kids",
  "Sports & Outdoors",
  "Toys & Games",
  "Garden & Outdoor",
  "Tools & Equipment",
  "Pets",
  "Hobbies & Leisure",
  "Collectibles & Art",
  "Business & Industrial",
  "Services",
  "Jobs",
  "Miscellaneous",
  "Others",
];
