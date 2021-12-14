import 'package:carousel_slider/carousel_slider.dart';
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:otlob_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:otlob_app/business_logic/shop_cubit/shop_states.dart';
import 'package:otlob_app/data/models/shop_app/banner_model.dart';
import 'package:otlob_app/data/models/shop_app/categories_model.dart';
import 'package:otlob_app/data/models/shop_app/home_model.dart';
import 'package:otlob_app/presentation/screens/product_details_screen.dart';
import 'package:otlob_app/shared/components/components.dart';
import 'package:otlob_app/shared/constants/my_colors.dart';

import 'category_item_screen.dart';


class ProductsScreen extends StatelessWidget {
  const ProductsScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state) {
        if (state is ShopSuccessChangeCartItemState) {
          showToast(
              msg: state.model.message, state: ToastStates.SUCCESS, seconds: 2);
        }
        if (state is ShopSuccessChangeFavoritesState) {
          showToast(
              msg: state.model.message, state: ToastStates.SUCCESS, seconds: 2);
        }
        if (state is ShopSuccessUpdateQuantityItemState) {
          showToast(
              msg: state.model.message, state: ToastStates.SUCCESS, seconds: 2);
        }
      },
      builder: (context, state) {
        var cubit = ShopCubit.get(context);
        return ConditionalBuilder(
          condition: cubit.homeModel != null && cubit.categoriesModel != null && cubit.bannerModel != null,
          builder: (context) =>
              homeBuilder(cubit.homeModel!, cubit.categoriesModel!,cubit.bannerModel! ,context),
          fallback: (context) => buildSearchLoadingIndicator(),
        );
      },
    );
  }

  Widget homeBuilder(
          HomeModel homeModel, CategoriesModel categoriesModel,BannersModel bannersModel ,context) =>
      SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CarouselSlider(
              items: bannersModel.data!
                  .map(
                    (banner) => Image(
                      image: NetworkImage(banner.image!),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  )
                  .toList(),
              options: CarouselOptions(
                height: 230,
                reverse: false,
                viewportFraction: 1,
                scrollDirection: Axis.horizontal,
                autoPlay: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 1500),
                autoPlayInterval: const Duration(seconds: 7),
                autoPlayCurve: Curves.easeInOutQuint,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: MyColors.light,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    height: 110,
                    child: Scrollbar(
                      thickness: 1,
                      child: ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) => buildCategories(
                            categoriesModel.data.categoriesList[index],
                            context),
                        separatorBuilder: (context, index) => const SizedBox(
                          width: 5,
                        ),
                        itemCount: categoriesModel.data.categoriesList.length,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    'New Products',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: MyColors.light,
                    ),
                  ),
                ],
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
              childAspectRatio: 1 / 1.97,
              children: List.generate(
                homeModel.data.products.length,
                (index) =>
                    buildGridProduct(homeModel.data.products[index], context),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      );

  Widget buildCategories(DataModel model, context) => InkWell(
        onTap: () {
          ShopCubit.get(context).getCategoryData(categoryId: model.id);
          navigateTo(context, CategoryItemScreen(name: model.name));
        },
        child: SizedBox(
          width: 110,
          child: Column(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration:  BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: MyColors.primary, width: 2),
                  image: DecorationImage(
                    image: NetworkImage(
                      model.image,
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Text(
                model.name.toUpperCase(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  fontFamily: 'Cairo',
                  color: MyColors.light,
                ),
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      );

  Widget positionedFill(text) => Positioned.fill(
        child: Align(
          alignment: const Alignment(1, -1),
          child: ClipRect(
            child: Banner(
              message: "Sale",
              textStyle: const TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
                fontSize: 12,
                letterSpacing: 0.5,
              ),
              location: BannerLocation.topEnd,
              color: MyColors.red,
              child: Container(
                height: 100,
              ),
            ),
          ),
        ),
      );

  Widget buildGridProduct(ProductModel product, context) => Card(
    color: MyColors.card,
    elevation: 3,
    margin: const EdgeInsets.all(4),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Stack(
          alignment: const Alignment(-1, -1),
          children: [
            InkWell(
              onTap: () {
                navigateTo(
                    context, ProductDetailsScreen(productModel: product));
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  color: Colors.white,
                  child: Image(
                    image: NetworkImage(product.image),
                    // fit: BoxFit.cover,
                    height: 180,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                ShopCubit.get(context).changeFavorites(product.id);
              },
              icon: CircleAvatar(
                radius: 15,
                backgroundColor: MyColors.primaryColor,
                child: Icon(
                  ShopCubit.get(context).favorites[product.id]!
                      ? Icons.favorite
                      : Icons.favorite_border_outlined,
                  color: MyColors.dark,
                  size: 18,
                ),
              ),
            ),
            if (product.discount > 0) positionedFill(product.discount),
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 15,
                  height: 1.4,
                  color: MyColors.light,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              if (product.discount > 0)
                Row(
                  children: [
                    Text(
                      'Save ${NumberFormat.currency(decimalDigits: 0, symbol: "").format(product.oldPrice - product.price)} (${product.discount}%)',
                      style: TextStyle(
                        color: MyColors.red,
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: Row(
            children: [
              Row(
                textBaseline: TextBaseline.alphabetic,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    NumberFormat.currency(decimalDigits: 0, symbol: "")
                        .format(product.price),
                    style: TextStyle(
                      fontSize: 18,
                      color: MyColors.primaryColor,
                      fontWeight: FontWeight.w900,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  Text(
                    ' LE  ',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: MyColors.light,
                    ),
                  ),
                ],
              ),
              if (product.discount > 0)
                Text(
                  ' ${NumberFormat.currency(decimalDigits: 0, symbol: "").format(product.oldPrice)} LE',
                  style: TextStyle(
                    fontSize: 15,
                    color: MyColors.light.withOpacity(0.6),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ShopCubit.get(context).productsQuantity[product.id] ==
                  null
              ? primaryButton(
                  text: "Add To Cart",
                  onPressed: () {
                    ShopCubit.get(context).changeCartItem(product.id);
                  },
                  height: 35,
                  radius: 15,
                  fontSize: 18,
                  isUpperCase: false,
                )
              : SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            ShopCubit.get(context)
                                .changeQuantityItem(product.id);
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: MyColors.green,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: MyColors.primary,
                                    blurRadius: 1,
                                    offset: const Offset(1, 1),
                                  )
                                ]),
                            child: const Icon(
                              Icons.add,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      Text(
                        ShopCubit.get(context)
                            .productsQuantity[product.id]
                            .toString(),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: MyColors.primary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: GestureDetector(
                          onTap: () {
                            ShopCubit.get(context).changeQuantityItem(
                              product.id,
                              increment: false,
                            );
                          },
                          child: Container(
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                                color: MyColors.green,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: MyColors.primary,
                                    blurRadius: 2,
                                    offset: const Offset(1, 1),
                                  )
                                ]),
                            child: const Icon(
                              Icons.remove,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    ),
  );
}
