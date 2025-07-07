import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:yardify/mobile/dashboard/sellers/create_listing/create_listing.dart';
import 'package:yardify/mobile/dashboard/sellers/demo_profile_row.dart';
import 'package:yardify/routes.dart';
import 'package:yardify/widgets/constant.dart';
import 'package:yardify/widgets/custom_button.dart';

class SellersDashboard extends StatelessWidget {
  const SellersDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    String? imageUrl;

    Future<Widget> image() async {
      // ignore: unnecessary_null_comparison
      if (imageUrl == null || imageUrl.isEmpty) {
        return Placeholder();
      } else {
        return Image.network(imageUrl, fit: BoxFit.cover);
      }
    }

    Widget buildImageWidget() {
      return FutureBuilder<Widget>(
        future: image(), // your async function
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(); // or a placeholder widget
          } else if (snapshot.hasError) {
            return Text('Error loading image');
          } else {
            return snapshot.data ?? Placeholder(); // fallback if null
          }
        },
      );
    }

    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard", style: TextStyle(fontSize: 16)),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 20,
              children: [
                Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade400,
                        blurRadius: 2,
                        offset: Offset(0, 0.6),
                      ),
                    ],
                    shape: BoxShape.circle,
                  ),
                  padding: EdgeInsets.all(1),
                  width: 50,
                  height: 50,
                  child: ProfileImageWidget(),
                ),
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      backgroundColor: Colors.lightBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateListing(),
                        ),
                      );
                    },
                    child: Row(
                      spacing: 4,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add, size: 25),
                        Text("Create listing", style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Overview",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 100,
              child: ListView(
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      buildWidgetCard(title: '', subtitle: '', icon: Icon(FeatherIcons.messageCircle),),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: ListTile(
                            title: Text(
                              '0',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text("Active listing"),
                            trailing: Icon(FeatherIcons.tag, size: 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Text(
              "Performance",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: ListView(
                children: [
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: ListTile(
                            title: Text(
                              '\$0.00',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text("Payout not available"),
                            trailing: Icon(
                              Icons.attach_money_outlined,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: ListTile(
                            title: Text(
                              '0',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text("Clicks on listing"),
                            trailing: Icon(Icons.ads_click_rounded, size: 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    spacing: 10,
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: ListTile(
                            title: Text(
                              '0',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text("Ratings"),
                            trailing: Icon(Icons.star_rounded, size: 30),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: ListTile(
                            title: Text(
                              '0',
                              style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text("New followers"),
                            trailing: Icon(Icons.person, size: 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class buildWidgetCard extends StatelessWidget {
  final String title;
  final Icon icon;
  final String subtitle;
  const buildWidgetCard({
    super.key,
    required this.title,
    required this.icon,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Text(subtitle),
          trailing: icon
        ),
      ),
    );
  }
}

class ProfileImageWidget extends StatefulWidget {
  @override
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
          return Container(
            width: 100,
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
          // Handle error or missing data
          return Container(width: 100, height: 100, child: Icon(Icons.person));
        }

        final userData = snapshot.data!.data() as Map<String, dynamic>;
        final profileImageUrl = userData['profilePic'];

        if (profileImageUrl.isEmpty) {
          return Container(width: 100, height: 100, child: Icon(Icons.person));
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
