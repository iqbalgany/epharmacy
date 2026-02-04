// import 'package:epharmacy/cubits/auth/auth_cubit.dart';
// import 'package:epharmacy/presentations/pages/home_page.dart';
// import 'package:epharmacy/presentations/pages/signin_page.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

// class AuthWrapperPage extends StatelessWidget {
//   const AuthWrapperPage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<AuthCubit, AuthState>(
//       builder: (context, state) {
//         if (state.status == AuthStatus.initial ||
//             state.status == AuthStatus.loading) {
//           return const Scaffold(
//             body: Center(child: CircularProgressIndicator()),
//           );
//         }

//         if (state.status == AuthStatus.success) {
//           return const HomePage();
//         }

//         return SigninPage();
//       },
//     );
//   }
// }
