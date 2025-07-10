// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yardify/mobile/auth/authCheck/auth_service.dart';
import 'package:yardify/mobile/database/item_list.dart';
import 'package:yardify/routes.dart';
import 'package:yardify/widgets/custom_button.dart';
import 'package:yardify/widgets/snack_bar.dart';

class ProfileScreen extends StatefulWidget {
  final String? title;
  final bool signup;
  const ProfileScreen({super.key, required this.title, required this.signup});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _key = GlobalKey();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _userName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _telephone = TextEditingController();

  // ignore: unused_field
  Widget _profileImage = CircularProgressIndicator();
  final userService = UserService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (auth.currentUser != null) {
      loadAndDisplayImage(auth.currentUser!.uid);
    }
    userService.requestPermissions();
  }

  Future<void> loadAndDisplayImage(String uid) async {
    Widget image = await UserService().loadProfileImage(uid);
    setState(() {
      _profileImage = image;
    });
  }

  Future<String?> updateProfilePicture() async {
    String? imageUrl = await userService.addProfilePic();
    if (imageUrl != null) {
      try {
        await userService.updateProfilePic(auth.currentUser!.uid, imageUrl);
      } catch (e) {
        print(e);
      }
      print('Profile picture uploaded: $imageUrl');
      return imageUrl;
    } else {
      imageUrl = '';
      try {
        await userService.updateProfilePic(auth.currentUser!.uid, imageUrl);
      } catch (e) {
        print(e);
        return null;
      }
      return imageUrl;
    }
  }

  @override
  Widget build(BuildContext context) {
    void handleSubmit() async {
      final user = AuthService().currentUser;
      if (_key.currentState!.validate()) {
        final name = _name.text;
        final userName = _userName.text;
        String formemail = _email.text;
        final telephone = int.parse(_telephone.text);
        if (formemail.isEmpty) {
          formemail = user!.email!;
        }
        try {
          await UserService().addUser(name, userName, formemail, telephone);
          Navigator.pushReplacementNamed(context, AppRouter.authgate);
        } catch (e) {
          displaySnackBar(context, "Error Happened");
        }
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(widget.title!),
        centerTitle: widget.signup == true ? false : true,
        leading: widget.signup == false
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            : Container(),
        actions: [
          widget.signup == false
              ? IconButton(
                  onPressed: () {
                    handleSubmit();
                  },
                  icon: Icon(Icons.check_rounded),
                )
              : Container(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: SingleChildScrollView(
          child: Column(
            spacing: 30,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      //add profile picture
                      UserService().addProfilePic();
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(300),
                      child: Container(
                        width: 200,
                        height: 200,
                        padding: EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade400,
                          shape: BoxShape.circle,
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(300),
                          child: ProfileImageWidget(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Form(
                key: _key,
                child: Column(
                  spacing: 8,
                  children: [
                    TextFormField(
                      controller: _name,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: _userName,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    widget.signup == false
                        ? TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                            ),
                          )
                        : Container(),
                    widget.signup == false ? SizedBox(height: 10) : Container(),
                    TextFormField(
                      controller: _telephone,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              widget.signup == true
                  ? CustomButton(
                      btntext: widget.signup ? 'Confirm' : "Update Profile",
                      bgcolor: Colors.black,
                      textcolor: Colors.white,
                      isBoldtext: true,
                      size: 18,
                      onpress: () {
                        // Handle profile update logic
                        handleSubmit();
                        displaySnackBar(
                          context,
                          "Profile updated successfully!",
                        );
                      },
                    )
                  : Container(),
            ],
          ),
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

        if (profileImageUrl == null || profileImageUrl.isEmpty) {
          return Container(width: 100, height: 100, child: Icon(Icons.person));
        }
        
        final imageUrl = auth.currentUser!.photoURL;

        return Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            image: DecorationImage(
              image: NetworkImage(imageUrl!),
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
