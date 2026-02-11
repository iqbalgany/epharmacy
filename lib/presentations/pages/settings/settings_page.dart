// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:epharmacy/presentations/cubits/auth/auth_cubit.dart';
import 'package:epharmacy/presentations/cubits/profile/profile_cubit.dart';
import 'package:epharmacy/presentations/pages/auth/signin_page.dart';
import 'package:epharmacy/presentations/pages/profile/profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final user = state.user;
          return SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 60),
                Center(
                  child: Image.asset(
                    user?.profileImage == null
                        ? 'assets/images/profile.jpg'
                        : user!.profileImage!,
                    height: 90,
                    width: 90,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  user?.firstName == null || user?.lastName == null
                      ? 'Guest User'
                      : '${user!.firstName} ${user.lastName}',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                ListTile(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ProfilePage()),
                  ),
                  leading: Text(
                    'Profile',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
                ),
                Divider(thickness: 2),
                ListTile(
                  leading: Text(
                    'Address',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
                ),
                Divider(thickness: 2),
                ListTile(
                  leading: Text(
                    'Track Order Status',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
                ),
                Divider(thickness: 2),
                ListTile(
                  leading: Text(
                    'Order History',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
                ),
                Divider(thickness: 2),
                BlocListener<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state.status == AuthStatus.success) {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => SigninPage()),
                        (route) => false,
                      );
                    }

                    if (state.status == AuthStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.errorMessage ?? 'Failed to Sign Out',
                          ),
                        ),
                      );
                    }
                  },
                  child: ListTile(
                    onTap: () => context.read<AuthCubit>().signOut(),
                    leading: Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    trailing: Icon(Icons.arrow_forward_ios_rounded, size: 20),
                  ),
                ),
                Divider(thickness: 2),
              ],
            ),
          );
        },
      ),
    );
  }
}
