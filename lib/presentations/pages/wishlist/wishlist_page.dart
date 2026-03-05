import 'package:cached_network_image/cached_network_image.dart';
import 'package:epharmacy/core/constants/helpers.dart';
import 'package:epharmacy/presentations/cubits/wishlist/wishlist_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class WishlistPage extends StatelessWidget {
  const WishlistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Your Wishlist',
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          GestureDetector(
            onTap: () {
              context.read<WishlistCubit>().clearWishlist();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'Clear Wishlist',
                style: TextStyle(
                  color: Colors.blue,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: BlocBuilder<WishlistCubit, WishlistState>(
        builder: (context, state) {
          if (state.status == WishlistStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state.wishlist.isEmpty) {
            return Center(
              child: Text(
                "Wishlist is Empty",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            );
          }
          return SizedBox(
            height: MediaQuery.sizeOf(context).height,
            child: ListView.builder(
              shrinkWrap: false,
              itemCount: state.wishlist.length,
              padding: EdgeInsets.symmetric(horizontal: 10),
              itemBuilder: (context, index) {
                final wishlist = state.wishlist[index];
                return Container(
                  padding: EdgeInsets.all(15),
                  margin: EdgeInsets.symmetric(vertical: 5),
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
                          imageUrl: Helpers.getOptimizedUrl(
                            wishlist.image,
                            (MediaQuery.sizeOf(context).width * 0.25).toInt(),
                          ),
                          placeholder: (context, url) => Shimmer(
                            duration: Duration(seconds: 2),
                            interval: Duration(milliseconds: 500),
                            color: Colors.grey.shade300,
                            colorOpacity: 0.3,
                            enabled: true,
                            direction: ShimmerDirection.fromLBRT(),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width * 0.25,
                              height: MediaQuery.sizeOf(context).width * 0.1,
                              color: Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              wishlist.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text('\$${wishlist.price}'),
                          ],
                        ),
                      ),

                      IconButton(
                        visualDensity: VisualDensity.compact,
                        onPressed: () {
                          context.read<WishlistCubit>().deleteProduct(index);
                        },
                        icon: Icon(Icons.delete, color: Colors.black),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
