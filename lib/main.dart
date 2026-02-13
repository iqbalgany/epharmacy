import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epharmacy/data/remote_datasource/address/address_remote_datasource.dart';
import 'package:epharmacy/data/remote_datasource/auth/auth_remote_datasource.dart';
import 'package:epharmacy/data/remote_datasource/cart/cart_remote_datasource.dart';
import 'package:epharmacy/data/remote_datasource/categories/categories_remote_datasource.dart';
import 'package:epharmacy/data/remote_datasource/product/product_remote_datasource.dart';
import 'package:epharmacy/firebase_options.dart';
import 'package:epharmacy/presentations/cubits/address/address_cubit.dart';
import 'package:epharmacy/presentations/cubits/auth/auth_cubit.dart';
import 'package:epharmacy/presentations/cubits/cart/cart_cubit.dart';
import 'package:epharmacy/presentations/cubits/categories/categories_cubit.dart';
import 'package:epharmacy/presentations/cubits/product/product_cubit.dart';
import 'package:epharmacy/presentations/cubits/profile/profile_cubit.dart';
import 'package:epharmacy/presentations/pages/auth/signin_page.dart';
import 'package:epharmacy/presentations/pages/main_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(AuthRemoteDatasource())),
        BlocProvider(
          create: (context) => CategoriesCubit(CategoriesRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => ProductCubit(ProductRemoteDatasource()),
        ),
        BlocProvider(
          create: (context) => CartCubit(
            CartRemoteDatasource(
              FirebaseFirestore.instance,
              FirebaseAuth.instance,
            ),
          ),
        ),
        BlocProvider(create: (context) => ProfileCubit()),
        BlocProvider(
          create: (context) => AddressCubit(
            AddressRemoteDatasource(
              FirebaseAuth.instance,
              FirebaseFirestore.instance,
            ),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: AppBarTheme(backgroundColor: Colors.white),
        ),
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Scaffold(
                body: const Center(child: CircularProgressIndicator()),
              );
            } else if (snapshot.hasData) {
              return const MainPage(intialIndex: 0);
            } else {
              return const SigninPage();
            }
          },
        ),
      ),
    );
  }
}
