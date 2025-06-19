import 'package:flutter/material.dart';
import 'package:zellyshop/auth/db/sharedpref_user_info.dart';
import 'package:zellyshop/widget/misc.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

UserInfo? user;

final TextEditingController nameController = TextEditingController();
final TextEditingController emailController = TextEditingController();
final TextEditingController userNameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();

class _EditProfileState extends State<EditProfile> {
  @override
  void initState() {
    super.initState();
    loadUser();
  }

  void loadUser() async {
    UserInfo? loadedUser = await UserStorage.loadUser();
    if (loadedUser != null) {
      setState(() {
        user = loadedUser;
        nameController.text = user?.name ?? '';
        emailController.text = user?.email ?? '';
        userNameController.text = user?.userName ?? '';
        phoneController.text = user?.phoneNumber ?? '';
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    userNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text("Edit Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              displaySnackBar(context, "Saving User Information");
            },
            icon: Icon(Icons.check_rounded),
          ),
        ],
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(color: Colors.grey.shade500),
                  child: Icon(Icons.person, size: 90),
                ),
              ),
              SizedBox(height: 30),
              Row(
                children: [
                  Text(
                    "Name",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                  ),
                ],
              ),
              TextFormField(
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: user?.name ?? 'name',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w300,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Email Address",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                  ),
                ],
              ),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: user?.email ?? 'emailaddress@gmail.com',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w300,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "User name",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                  ),
                ],
              ),
              TextFormField(
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  hintText: user?.userName ?? 'Pam Simmings',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w300,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Password",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                  ),
                ],
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '***********',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w300,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                  suffixIcon: Icon(Icons.visibility),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Text(
                    "Phone number",
                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
                  ),
                ],
              ),
              TextFormField(
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: user?.phoneNumber ?? '1(876)000-1111',
                  hintStyle: TextStyle(
                    color: Colors.grey.shade500,
                    fontWeight: FontWeight.w300,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  fillColor: Colors.grey.shade200,
                  filled: true,
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
