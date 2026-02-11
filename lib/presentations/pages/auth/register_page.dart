import 'package:epharmacy/presentations/cubits/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmationController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Register Page'),
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: 20),
                Center(
                  child: Icon(
                    Icons.medical_services_rounded,
                    color: Colors.red,
                    size: 80,
                  ),
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  enableSuggestions: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'input your email',
                    hintStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.black,
                      size: 20,
                    ),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Invalid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _firstNameController,
                  enableSuggestions: true,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'input your first name',
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
                    hintText: 'input your last name',
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
                TextFormField(
                  controller: _passwordController,
                  enableSuggestions: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'input your password',
                    hintStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.black,
                      size: 20,
                    ),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Password is empty';
                    } else if (value.length < 2) {
                      return 'Password is to short';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                TextFormField(
                  controller: _passwordConfirmationController,
                  enableSuggestions: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: 'input your password',
                    hintStyle: TextStyle(color: Colors.black),
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.black,
                      size: 20,
                    ),
                    alignLabelWithHint: true,
                  ),
                  validator: (value) {
                    if (value != _passwordController.text) {
                      return 'Password do not match';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                Divider(thickness: 2),
                SizedBox(height: 20),
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Text(
                      'All ready have and account? Signin',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                BlocListener<AuthCubit, AuthState>(
                  listenWhen: (previous, current) =>
                      previous.status != current.status,
                  listener: (context, state) {
                    if (state.status == AuthStatus.failure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            state.errorMessage ?? 'Authentication Error',
                          ),
                        ),
                      );
                    }

                    if (state.status == AuthStatus.success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Registration Successful')),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: SizedBox(
                    width: MediaQuery.sizeOf(context).width,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          context.read<AuthCubit>().signUp(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim(),
                            firstName: _firstNameController.text.trim(),
                            lastName: _lastNameController.text.trim(),
                            profileImage: null,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.red,
                      ),
                      child: Text('Register'),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
