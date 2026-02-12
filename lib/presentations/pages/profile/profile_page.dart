import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:epharmacy/presentations/cubits/profile/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  bool _isDataLoaded = false;

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  Future<void> selectProfileImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          image = File(pickedFile.path);
        });
      }
    } catch (e) {
      log('Error picking image: $e');
    }
  }

  ImageProvider getProfileImage(String? firestoreBase64) {
    if (image != null) {
      return FileImage(image!);
    }

    if (firestoreBase64 != null && firestoreBase64.isNotEmpty) {
      try {
        return MemoryImage(base64Decode(firestoreBase64));
      } catch (e) {
        log('Error decoding base64 image: $e');
        return AssetImage('assets/profile.jpg');
      }
    }
    return AssetImage('assets/profile.jpg');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.white, title: Text('Profile')),
      body: BlocConsumer<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.status == ProfileStatus.success) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Profile updated successfully'),
                backgroundColor: Colors.green,
              ),
            );
          }

          if (state.status == ProfileStatus.error) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.status == ProfileStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }
          if (state.status == ProfileStatus.error) {
            return Center(child: Text(state.errorMessage));
          }

          final user = state.user!;

          if (!_isDataLoaded) {
            _firstNameController.text = user.firstName ?? '';
            _lastNameController.text = user.lastName ?? '';
            _isDataLoaded = true;
          }

          return BlocBuilder<ProfileCubit, ProfileState>(
            builder: (context, state) {
              return SingleChildScrollView(
                child: Column(
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
                                border: Border.all(color: Colors.black),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: getProfileImage(user.profileImage),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 10,
                              child: RotatedBox(
                                quarterTurns: 3,
                                child: IconButton(
                                  style: IconButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: CircleBorder(),
                                  ),
                                  onPressed: selectProfileImage,
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ),
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
                            GestureDetector(
                              onTap: () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<ProfileCubit>().updateProfile(
                                    user: user,
                                    newFirstName: _firstNameController.text
                                        .trim(),
                                    newLastName: _lastNameController.text
                                        .trim(),
                                    newImageFile: image,
                                  );
                                }
                              },
                              child: Container(
                                width: MediaQuery.sizeOf(context).width,
                                padding: EdgeInsets.symmetric(vertical: 15),
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    "Submit",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
