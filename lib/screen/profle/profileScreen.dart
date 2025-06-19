import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:zellyshop/widget/appRoutes.dart';
import 'package:zellyshop/widget/misc.dart';

class Profilescreen extends StatefulWidget {
  const Profilescreen({super.key});

  @override
  State<Profilescreen> createState() => _ProfilescreenState();
}

String? gender;

class _ProfilescreenState extends State<Profilescreen> {
  final ImagePicker _picker = ImagePicker();
  File? _image;

  @override
  void initState() {
    super.initState();
    requestPermissions();
  }

  Future<void> _pickImageFromGallery() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _takePhoto() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<bool> requestPermissions() async {
    final statusCamera = await Permission.camera.status;
    final statusStorage = await Permission.storage.status;

    if (!statusCamera.isGranted) {
      await Permission.camera.request();
    }
    if (!statusStorage.isGranted) {
      await Permission.storage.request();
    }

    return statusCamera.isGranted && statusStorage.isGranted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Profile"), centerTitle: true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            //Image
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100,
                  height: 100,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade500,
                          ),
                          child:
                              _image != null
                                  ? Image.file(
                                    _image!,
                                    width: 200,
                                    height: 200,
                                    fit: BoxFit.cover,
                                  )
                                  : Icon(Icons.person, size: 90),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 6,
                        child: GestureDetector(
                          onTap: () {
                            showBottomSheetImage();
                          },
                          child: Container(
                            padding: EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade500,
                              shape: BoxShape.circle,
                            ),
                            child: Container(
                              padding: EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Icon(Icons.edit),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            ListTile(
              title: Text("Edit Profile"),
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.editprofile);
              },
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
            ListTile(
              title: Text("Account Settings"),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
            ListTile(
              title: Text("Privacy & Security"),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
            Divider(),
            ListTile(
              title: Text("Preferences & Customizations"),
              trailing: Icon(Icons.arrow_forward_ios),
            ),
          ],
        ),
      ),
    );
  }

  void showBottomSheetImage() {
    showBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(10),
              topLeft: Radius.circular(10),
            ),
            color: Colors.grey.shade200,
          ),
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Edit Profile Picture",
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 22),
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text(
                  "Choose from gallery",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                onTap: () {
                  _pickImageFromGallery();
                },
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Take Photo",
                  style: TextStyle(fontWeight: FontWeight.w400),
                ),
                onTap: () {
                  _takePhoto();
                },
              ),
              Divider(),
              ListTile(
                title: Text(
                  "Delete Picture",
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.redAccent,
                  ),
                ),
                onTap: () {
                  displaySnackBar(context, "Feature in development");
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Edit Profile Picture"),
          actions: [
            TextButton(
              onPressed: () {
                _pickImageFromGallery();
              },
              child: Text("Choose from gallery"),
            ),
            TextButton(
              onPressed: () {
                _takePhoto();
              },
              child: Text("Take photo"),
            ),
            TextButton(
              onPressed: () {
                displaySnackBar(context, "Feature in development");
              },
              child: Text("Remove Photo"),
            ),
          ],
        );
      },
    );
  }
}
