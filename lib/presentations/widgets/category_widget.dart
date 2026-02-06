import 'package:epharmacy/data/models/category_model.dart';
import 'package:epharmacy/presentations/cubits/categories/categories_cubit.dart';
import 'package:epharmacy/presentations/cubits/product/product_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({super.key});

  @override
  State<CategoryWidget> createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  int _selectedCategoryIndex = 0;

  @override
  void initState() {
    super.initState();
    context.read<CategoriesCubit>().getCategories();
  }

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

        List<CategoryModel> sortedCategories = List.from(state.categories);
        sortedCategories.sort((a, b) {
          String nameA = a.name ?? '';
          String nameB = b.name ?? '';
          if (nameA == 'All') return -1;
          if (nameB == 'All') return 1;

          return nameA.compareTo(nameB);
        });

        return SizedBox(
          height: 50,
          child: ListView.builder(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            itemCount: sortedCategories.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              final category = sortedCategories[index];
              final isSelected = _selectedCategoryIndex == index;
              return InkWell(
                borderRadius: BorderRadius.circular(15),
                onTap: () {
                  setState(() {
                    _selectedCategoryIndex = index;
                  });

                  context.read<ProductCubit>().getProductByCategory(
                    category.name ?? '',
                  );
                },
                child: Padding(
                  padding: EdgeInsets.all(5),
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: isSelected ? Colors.blue : Colors.white,
                      border: Border.all(color: Colors.blue, width: 2),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Center(
                      child: Text(
                        category.name ?? '',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.blue,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
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
