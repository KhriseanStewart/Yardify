import 'package:flutter/material.dart';
import 'package:zellyshop/auth/db/sharedpref_user_info.dart';
import 'package:zellyshop/widget/appRoutes.dart';

class ProfileLogin extends StatefulWidget {
  const ProfileLogin({super.key});

  @override
  State<ProfileLogin> createState() => _ProfileLoginState();
}

final TextEditingController nameController = TextEditingController();
final TextEditingController userNameController = TextEditingController();
final TextEditingController phoneNumberController = TextEditingController();

class _ProfileLoginState extends State<ProfileLogin> {
  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    final email = args['email'];
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await UserStorage.saveUser(
                UserInfo(
                  name: nameController.text.trim().toLowerCase(),
                  userName: userNameController.text.trim(),
                  phoneNumber: phoneNumberController.text,
                  email: email,
                ),
              );
              Navigator.pushReplacementNamed(
                context,
                AppRoutes.login,
                arguments: {
                  'name': nameController.text,
                  'userName': userNameController.text,
                  'phoneNumber': phoneNumberController.text,
                  'email': email
                },
              );
            },
            icon: Icon(Icons.check_rounded),
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
              controller: nameController,
              decoration: InputDecoration(
                hintText: 'Khrisean Stewart',
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Password';
                }
                return null;
              },
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
              keyboardType: TextInputType.text,
              controller: userNameController,
              decoration: InputDecoration(
                hintText: 'stewartkhrisean8',
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Password';
                }
                return null;
              },
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
              controller: phoneNumberController,
              decoration: InputDecoration(
                hintText: '1(876) 111-2222',
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
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Enter Password';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}
