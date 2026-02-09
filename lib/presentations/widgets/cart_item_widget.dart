// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cached_network_image/cached_network_image.dart';
import 'package:epharmacy/constants/helpers.dart';
import 'package:epharmacy/data/models/cart_model.dart';
import 'package:epharmacy/presentations/cubits/cart/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemWidget extends StatelessWidget {
  final CartModel item;
  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsetsGeometry.all(8),
          child: CachedNetworkImage(
            fit: BoxFit.cover,
            imageUrl: getOptimizedUrl(
              item.image ?? '',
              MediaQuery.sizeOf(context).width.toInt(),
            ),
            placeholder: (context, url) =>
                Center(child: CircularProgressIndicator()),
          ),
        ),
        Expanded(
          child: Wrap(
            direction: Axis.vertical,
            children: [
              Container(
                padding: EdgeInsets.only(left: 14),
                child: Text(
                  item.name ?? '',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  IconButton(
                    onPressed: () {
                      context.read<CartCubit>().removeCartItem(item);
                    },
                    icon: Icon(Icons.remove),
                  ),

                  Padding(
                    padding: EdgeInsets.all(8),

                    child: Text(item.quantity.toString()),
                  ),

                  IconButton(
                    onPressed: () {
                      context.read<CartCubit>().increaseQuantity(item);
                    },
                    icon: Icon(Icons.add),
                  ),
                ],
              ),
            ],
          ),
        ),

        IconButton(
          onPressed: () {
            context.read<CartCubit>().removeCartItem(item);
          },
          icon: Icon(Icons.delete, color: Colors.red),
        ),

        Padding(
          padding: EdgeInsets.all(14),
          child: Text(
            '\$${item.cost}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
        ),

        Divider(thickness: 2, color: Colors.black),
      ],
    );
  }
}
