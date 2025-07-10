import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yardify/routes.dart';
import 'package:yardify/widgets/loading.dart';

class ProfileImageWidget extends StatefulWidget {
  final String userId; // pass the user ID to fetch data

  const ProfileImageWidget({required this.userId});

  @override
  _ProfileImageWidgetState createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  // ignore: unused_field
  Widget _imageWidget = LoadingScreen(color: Colors.white);

  @override
  void initState() {
    super.initState();
    loadAndDisplayImage();
  }

  void loadAndDisplayImage() async {
    if (auth.currentUser!.photoURL != null) {
      String imageTwo = auth.currentUser!.photoURL!;
      setState(() {
        _imageWidget = ClipOval(
          child: Image.network(
            imageTwo,
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

  final userId = auth.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: 100,
            height: 100,
            child: Center(child: LoadingScreen(color: Colors.white)),
          );
        }
        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          // Handle error or missing data
          return SizedBox(width: 100, height: 100, child: Icon(Icons.person));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final profileImageUrl = userData['profilePic'];

        if (profileImageUrl == null || profileImageUrl.isEmpty) {
          return SizedBox(width: 100, height: 100, child: Icon(Icons.person));
        }

        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(profileImageUrl),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
