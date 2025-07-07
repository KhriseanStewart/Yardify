import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yardify/routes.dart';

class DemoProfileRow extends StatelessWidget {
  const DemoProfileRow({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
      future: FirebaseFirestore.instance
          .collection('users')
          .doc(auth.currentUser!.uid)
          .get(),
      builder: (context, userSnapshot) {
        if (userSnapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (userSnapshot.hasError) {
          return Center(child: Text('Error: ${userSnapshot.error}'));
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
                    width: 50,
                    height: 50,
                    padding: EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ProfileImageWidget(),
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
                  "Followed",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class ProfileImageWidget extends StatefulWidget {
  const ProfileImageWidget({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfileImageWidgetState createState() => _ProfileImageWidgetState();
}

class _ProfileImageWidgetState extends State<ProfileImageWidget> {
  @override
  void initState() {
    super.initState();
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
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          // Handle error or missing data
          return SizedBox(width: 100, height: 100, child: Icon(Icons.person));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final profileImageUrl = userData['profilePic'];

        if (profileImageUrl.isEmpty) {
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
