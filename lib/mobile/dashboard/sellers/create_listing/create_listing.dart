import 'package:flutter/material.dart';
import 'package:yardify/mobile/dashboard/sellers/demo_profile_row.dart';
import 'package:yardify/routes.dart';
import 'package:yardify/widgets/constant.dart';

class CreateListing extends StatelessWidget {
  const CreateListing({super.key});

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
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        leading: IconButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Are you sure?"),
                  content: Text(
                    "Are you sure you want to exit? Your current setup\n will not be saved and you may need to start over.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                          context,
                          AppRouter.mainlayout,
                        );
                      },
                      child: Text("Ok"),
                    ),
                  ],
                );
              },
            );
          },
          icon: Icon(Icons.arrow_back),
          style: IconButton.styleFrom(backgroundColor: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              onPressed: () {},
              icon: Icon(Icons.check_outlined),
              style: IconButton.styleFrom(backgroundColor: Colors.white),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          spacing: 4,
          children: [
            SizedBox(
              height: SizeConfig.heightPercentage(40),
              width: double.infinity,
              child: buildImageWidget(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Title',
                      border: InputBorder.none,
                    ),
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600),
                  ),
                  Row(
                    children: [
                      Text(
                        "JMD",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Price',
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined),
                      SizedBox(width: 10),
                      Expanded(
                        child: TextFormField(
                          decoration: InputDecoration(
                            hintText: 'Location',
                            border: InputBorder.none,
                          ),
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            DemoProfileRow(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                children: [
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Description',
                      border: OutlineInputBorder(),
                    ),
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
