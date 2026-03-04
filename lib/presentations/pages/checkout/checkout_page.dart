import 'dart:developer';

import 'package:epharmacy/data/models/cart_model.dart';
import 'package:epharmacy/presentations/cubits/address/address_cubit.dart';
import 'package:epharmacy/presentations/cubits/cart/cart_cubit.dart';
import 'package:epharmacy/presentations/cubits/order/order_cubit.dart';
import 'package:epharmacy/presentations/cubits/profile/profile_cubit.dart';
import 'package:epharmacy/presentations/cubits/stripe/stripe_cubit.dart';
import 'package:epharmacy/presentations/widgets/cart_item_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: BlocBuilder<AddressCubit, AddressState>(
        builder: (context, addressState) {
          final address = addressState.address;
          return Column(
            children: [
              SizedBox(height: 20),
              Center(
                child: Text(
                  'Your Address',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 25),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Address',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              address?.address ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'City',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              address?.city ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'House Number',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              address?.houseNumber ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'ZipCode',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              address?.zipCode.toString() ?? '',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ),
              ),
              Text(
                'Your Products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Expanded(
                child: BlocBuilder<CartCubit, CartState>(
                  builder: (context, cartState) {
                    final List<CartModel>? carts = cartState.carts;

                    if (carts == null || carts.isEmpty) {
                      return Center(child: Text('No items in cart'));
                    }

                    return ListView.separated(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      itemCount: carts.length + 1,
                      separatorBuilder: (context, index) =>
                          SizedBox(height: 10),
                      itemBuilder: (context, index) {
                        if (index == carts.length) {
                          return Column(
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                  Text(
                                    '\$${cartState.grandTotal.toString()}',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 20),
                              BlocListener<StripeCubit, StripeState>(
                                listener: (context, stripeState) {
                                  if (stripeState.status ==
                                      StripeStatus.success) {
                                    final currentUser = context
                                        .read<ProfileCubit>()
                                        .state
                                        .user;

                                    if (currentUser != null &&
                                        address != null) {
                                      context.read<OrderCubit>().createOrder(
                                        uid: currentUser.uid,
                                        user: currentUser,
                                        address: address,
                                        total: cartState.grandTotal,
                                        products: carts,
                                      );
                                    }
                                  } else if (stripeState.status ==
                                      StripeStatus.failure) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        backgroundColor: Colors.red,
                                        content: Text(
                                          'Pembayaran Gagal : ${stripeState.errorMessage}',
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: BlocBuilder<ProfileCubit, ProfileState>(
                                  builder: (context, profileState) {
                                    final currentUser = profileState.user;
                                    return BlocListener<OrderCubit, OrderState>(
                                      listener: (context, orderState) {
                                        if (orderState.status ==
                                            OrderStatus.error) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.red,
                                              content: Text(
                                                orderState.errorMessage
                                                    .toString(),
                                              ),
                                            ),
                                          );
                                        }

                                        if (orderState.status ==
                                            OrderStatus.success) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              backgroundColor: Colors.green,
                                              content: Text('Success'),
                                            ),
                                          );

                                          context.read<CartCubit>().clearCart();

                                          Navigator.pop(context);
                                        }
                                      },
                                      child: SizedBox(
                                        width: MediaQuery.sizeOf(context).width,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 10,
                                            ),
                                            backgroundColor: Colors.blue,
                                            elevation: 2,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                          onPressed: () {
                                            if (currentUser != null &&
                                                address != null) {
                                              log(
                                                "Memulai Pembayaran Stripe...",
                                              );
                                              context
                                                  .read<StripeCubit>()
                                                  .processStripePayment(
                                                    cartState.grandTotal,
                                                  );
                                              // final uid = currentUser.uid;

                                              // if (uid.isNotEmpty) {
                                              //
                                              // } else {
                                              //   ScaffoldMessenger.of(
                                              //     context,
                                              //   ).showSnackBar(
                                              //     SnackBar(
                                              //       content: Text(
                                              //         'User ID tidak valid',
                                              //       ),
                                              //     ),
                                              //   );
                                              // }
                                            } else {
                                              ScaffoldMessenger.of(
                                                context,
                                              ).showSnackBar(
                                                SnackBar(
                                                  content: Text(
                                                    'Data user atau alamat belum lengkap',
                                                  ),
                                                ),
                                              );
                                            }
                                          },
                                          child: Text(
                                            'Place Order',
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height: 50),
                            ],
                          );
                        }

                        final item = carts[index];
                        return CartItemWidget(item: item);
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
