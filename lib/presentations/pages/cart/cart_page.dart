import 'package:epharmacy/presentations/cubits/cart/cart_cubit.dart';
import 'package:epharmacy/presentations/pages/main_page.dart';
import 'package:epharmacy/presentations/widgets/cart_item_widget.dart';
import 'package:epharmacy/presentations/widgets/check_out_bottom_nav.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: () {
              context.read<CartCubit>().clearCart();
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Clear carts',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
        title: Text(
          'Carts',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: Theme.of(context).iconTheme,
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.status == CartStatus.error) {
            return Center(child: Text(state.message));
          }

          if (state.status == CartStatus.loading) {
            return SizedBox(
              height: MediaQuery.sizeOf(context).height * 0.7,
              child: const Center(child: CircularProgressIndicator()),
            );
          }

          if (state.carts!.isNotEmpty) {
            return ListView.separated(
              itemCount: state.carts!.length,
              separatorBuilder: (context, index) => SizedBox(height: 10),
              padding: EdgeInsets.all(10),
              itemBuilder: (context, index) {
                return CartItemWidget(item: state.carts![index]);
              },
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No items in the cart'),
                SizedBox(height: 20),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll<Color>(Colors.blue),
                    foregroundColor: WidgetStatePropertyAll<Color>(
                      Colors.white,
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(intialIndex: 0),
                      ),
                    );
                  },
                  child: Text(
                    'Back To Shopping',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),

      bottomNavigationBar: CheckOutBottomNav(),
    );
  }
}
