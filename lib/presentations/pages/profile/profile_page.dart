import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  File? image;
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;

      final imageTemporary = File(image.path);

      setState(() {
        this.image = imageTemporary;
      });
    } catch (e) {
      rethrow;
    }
  }

  void selectProfileImage() async {
    final res = await pickImage();
    if (res != null) {
      setState(() {
        image = File(res.files.first.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, title: Text('Profile')),
      body: Column(
        children: [
          SizedBox(height: 60),
          Center(
            child: GestureDetector(
              onTap: selectProfileImage,
              child: Stack(
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.black, width: 2),
                      image: DecorationImage(
                        image: image != null
                            ? FileImage(image!)
                            : AssetImage('assets/profile.jpg') as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Icon(Icons.edit, color: Colors.blue, size: 28),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    enableSuggestions: true,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'First Name',
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Colors.black,
                        size: 20,
                      ),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'First name is empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                  TextFormField(
                    controller: _lastNameController,
                    enableSuggestions: true,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      hintText: 'Last Name',
                      hintStyle: TextStyle(color: Colors.black),
                      prefixIcon: Icon(
                        Icons.person_outline,
                        color: Colors.black,
                        size: 20,
                      ),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Last name is empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
