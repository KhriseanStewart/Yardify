import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yardify/mobile/dashboard/sellers/demo_profile_row.dart';
import 'package:yardify/mobile/database/item_list.dart';
import 'package:yardify/routes.dart';
import 'package:yardify/widgets/auto_complete.dart';
import 'package:yardify/widgets/constant.dart';

class CreateListing extends StatefulWidget {
  const CreateListing({super.key});

  @override
  State<CreateListing> createState() => _CreateListingState();
}

class _CreateListingState extends State<CreateListing> {
  final TextEditingController titleEditor = TextEditingController();
  final TextEditingController priceEditor = TextEditingController();
  final TextEditingController locationEditor = TextEditingController();
  final TextEditingController descriptionEditor = TextEditingController();
  final TextEditingController selectedcategoryEditor = TextEditingController();
  String? selectedValue;
  String? imageUrl;
  bool isTapped = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);

    Future<Widget> image() async {
      // ignore: unnecessary_null_comparison
      if (imageUrl == null || imageUrl!.isEmpty) {
        return Icon(
          Icons.image_outlined,
          size: SizeConfig.widthPercentage(60),
          color: Colors.grey,
        );
      } else {
        return Image.file(File(imageUrl!), fit: BoxFit.cover);
      }
    }

    Widget buildImageWidget() {
      return FutureBuilder<Widget>(
        future: image(), // your async function
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator(color: Theme.of(context).primaryColorLight,); // or a placeholder widget
          } else if (snapshot.hasError) {
            return Text('Error loading image');
          } else {
            return snapshot.data ?? Icon(Icons.image); // fallback if null
          }
        },
      );
    }

    void _showDialog() {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Are you sure?"),
            content: Text(
              "Are you sure you want to exit? Your current setup will not be saved and you may need to start over.",
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
                    AppRouter.mobiledashboard,
                  );
                },
                child: Text("Ok"),
              ),
            ],
          );
        },
      );
    }

    void handleCategorySelected(String? category) {
      setState(() {
        selectedcategoryEditor.text = category!;
      });
    }

    final picker = ImagePicker();

    Future<void> pickAndUploadImage() async {
      setState(() {
        isTapped = true;
      });
      final pickedFile = await picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          imageUrl = pickedFile.path;
          isTapped = false;
        });

        print(imageUrl);
      } else {
        setState(() {
          isTapped = false;
        });
        print('No image selected.');
      }
    }

    void handleSubmit() async {
      setState(() {
        isTapped = true;
      });
      final name = titleEditor.text;
      final description = descriptionEditor.text;
      final price = priceEditor.text;
      final category = selectedcategoryEditor.text;
      final location = locationEditor.text;
      try {
        int priceInt = int.parse(price);
        await UploadDocument().addListing(
          category,
          imageUrl!,
          location,
          name,
          priceInt,
          description,
        );
        setState(() {
          isTapped = false;
        });
      } on FirebaseException catch (e) {
        setState(() {
          isTapped = false;
        });
        print(e);
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade50,
        leading: IconButton(
          onPressed: () {
            _showDialog();
          },
          icon: Icon(Icons.arrow_back),
          style: IconButton.styleFrom(backgroundColor: Colors.white),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              onPressed: () {
                isTapped ? null : handleSubmit();
              },
              icon: Icon(
                Icons.check_outlined,
                color: isTapped ? Colors.grey.shade300 : Colors.black,
              ),
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
              child: GestureDetector(
                onTap: isTapped ? null : pickAndUploadImage,
                child: buildImageWidget(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: titleEditor,
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
                          controller: priceEditor,
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
                  DropdownButton<String>(
                    value: selectedValue,
                    hint: Text(selectedValue ?? 'Select Condition'),
                    onTap: () {
                      print(selectedValue);
                    },
                    items: [
                      DropdownMenuItem(value: 'new', child: Text('New')),
                      DropdownMenuItem(
                        value: 'used-new',
                        child: Text('Used - Like New'),
                      ),
                      DropdownMenuItem(
                        value: 'used-good',
                        child: Text('Used - Good'),
                      ),
                      DropdownMenuItem(
                        value: 'used-fair',
                        child: Text('Used Fair'),
                      ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedValue = newValue;
                      });
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(Icons.location_on_outlined),
                            SizedBox(width: 10),
                            Expanded(
                              child: TextFormField(
                                controller: locationEditor,
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
                      ),
                      Expanded(
                        child: CategoryAutocomplete(
                          onCategorySelected: handleCategorySelected,
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
                    controller: descriptionEditor,
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
