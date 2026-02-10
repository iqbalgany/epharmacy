import 'package:cached_network_image/cached_network_image.dart';
import 'package:epharmacy/constants/helpers.dart';
import 'package:epharmacy/core/utils/formatters.dart';
import 'package:epharmacy/data/models/cart_model.dart';
import 'package:epharmacy/presentations/cubits/cart/cart_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CartItemWidget extends StatelessWidget {
  final CartModel item;
  const CartItemWidget({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: getOptimizedUrl(
                item.image ?? '',
                (MediaQuery.sizeOf(context).width * 0.25).toInt(),
              ),
              placeholder: (context, url) => Container(
                width: MediaQuery.sizeOf(context).width * 0.25,
                height: MediaQuery.sizeOf(context).width * 0.1,
                color: Colors.grey.shade300,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 14),
                  child: Text(
                    item.name ?? 'No Name',
                    maxLines: 1,

                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ),

                Row(
                  children: [
                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        context.read<CartCubit>().decreaseQuantity(item);
                      },
                      icon: Icon(Icons.remove, size: 16),
                    ),

                    Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(item.quantity.toString()),
                    ),

                    IconButton(
                      visualDensity: VisualDensity.compact,
                      onPressed: () {
                        context.read<CartCubit>().increaseQuantity(item);
                      },
                      icon: Icon(Icons.add, size: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                visualDensity: VisualDensity.compact,
                onPressed: () {
                  context.read<CartCubit>().removeCartItem(item);
                },
                icon: Icon(Icons.delete, color: Colors.red),
              ),
              Text(
                AppFormatters.formatRupiah(item.cost ?? 0),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
