import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileImageWidget extends StatefulWidget {
  final String userId; // pass the user ID to fetch data

  const ProfileImageWidget({required this.userId});

  @override
  _ProfileImageWidgetState createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  Widget _imageWidget = CircularProgressIndicator();

  @override
  void initState() {
    super.initState();
    loadAndDisplayImage();
  }

  void loadAndDisplayImage() async {
    // Fetch user document from Firestore
    DocumentSnapshot userDoc = await FirebaseFirestore.instance
        .collection('users') // your collection name
        .doc(widget.userId)
        .get();

    if (userDoc.exists && userDoc['profilePic'] != null) {
      String imageUrl = userDoc['profilePic'];
      setState(() {
        _imageWidget = ClipOval(
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            width: 100,
            height: 100,
          ),
        );
      });
    } else {
      // No image URL found, show placeholder
      setState(() {
        _imageWidget = Icon(Icons.person, size: 100);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle),
      width: 100,
      height: 100,
      child: _imageWidget,
    );
  }
}