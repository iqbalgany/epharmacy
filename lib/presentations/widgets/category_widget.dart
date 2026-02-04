import 'package:cached_network_image/cached_network_image.dart';
import 'package:epharmacy/constants/helpers.dart';
import 'package:epharmacy/presentations/cubits/categories/categories_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CategoriesCubit, CategoriesState>(
      builder: (context, state) {
        if (state.status == CategoriesStatus.loading) {
          return Center(child: CircularProgressIndicator());
        }
        if (state.status == CategoriesStatus.error) {
          return Center(child: Text(state.errorMessage));
        }
        return SizedBox(
          height: 150,
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: state.categories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final category = state.categories[index];
              return Padding(
                padding: EdgeInsets.all(5),
                child: Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blue),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 80,
                        child: CachedNetworkImage(
                          imageUrl: getOptimizedUrl(
                            category.image ?? '',
                            MediaQuery.sizeOf(context).width.toInt(),
                          ),
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                      ),
                      SizedBox(height: 5),
                      Text(
                        category.name ?? '',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
