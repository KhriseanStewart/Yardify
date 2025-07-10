import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/material.dart';
import 'package:yardify/mobile/dashboard/sellers/create_listing/create_listing.dart';
import 'package:yardify/mobile/screens/profile/profile.dart';
import 'package:yardify/routes.dart';
import 'package:yardify/widgets/constant.dart';

class SellersDashboard extends StatelessWidget {
  const SellersDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard", style: TextStyle(fontSize: 16)),
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacementNamed(context, AppRouter.authgate);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
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
                        Icon(Icons.add, size: 22),
                        Text("Create listing", style: TextStyle(fontSize: 16)),
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
                      buildWidgetCard(
                        title: '0',
                        subtitle: 'Active messagers',
                        icon: Icon(FeatherIcons.messageCircle),
                      ),
                      buildWidgetCard(
                        title: '0',
                        icon: Icon(FeatherIcons.tag, size: 30),
                        subtitle: "Active Listing",
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
                      buildWidgetCard(
                        title: '\$0.00',
                        icon: Icon(Icons.attach_money_outlined, size: 30),
                        subtitle: "Payout not available",
                      ),

                      buildWidgetCard(
                        title: '0',
                        icon: Icon(Icons.ads_click_rounded, size: 30),
                        subtitle: "Click on listing",
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    spacing: 10,
                    children: [
                      buildWidgetCard(
                        title: '0',
                        icon: Icon(Icons.star_rounded, size: 30),
                        subtitle: "Ratings",
                      ),

                      buildWidgetCard(
                        title: '0',
                        icon: Icon(Icons.person, size: 30),
                        subtitle: "New followers",
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
          border: Border.all(width: 1, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(6),
        ),
        child: ListTile(
          title: Text(
            title,
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(subtitle),
          trailing: icon,
        ),
      ),
    );
  }
}

// class ProfileImageWidget extends StatefulWidget {
//   @override
//   _ProfileImageWidgetState createState() => _ProfileImageWidgetState();
// }

// class _ProfileImageWidgetState extends State<ProfileImageWidget> {
//   @override
//   void initState() {
//     super.initState();
//   }

//   final userId = auth.currentUser!.uid;

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder(
//       stream: FirebaseFirestore.instance
//           .collection('users')
//           .doc(userId)
//           .snapshots(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return Container(
//             width: 100,
//             height: 100,
//             child: Center(child: CircularProgressIndicator()),
//           );
//         }
//         if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
//           // Handle error or missing data
//           return Container(width: 100, height: 100, child: Icon(Icons.person));
//         }

//         final userData = snapshot.data!.data() as Map<String, dynamic>;
//         final profileImageUrl = userData['profilePic'];

//         if (profileImageUrl.isEmpty) {
//           return Container(width: 100, height: 100, child: Icon(Icons.person));
//         }

//         return Container(
//           width: 100,
//           height: 100,
//           decoration: BoxDecoration(
//             shape: BoxShape.circle,
//             image: DecorationImage(
//               image: NetworkImage(profileImageUrl),
//               fit: BoxFit.cover,
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
