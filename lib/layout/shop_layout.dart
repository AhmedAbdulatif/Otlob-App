import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlob_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:otlob_app/business_logic/shop_cubit/shop_states.dart';
import 'package:otlob_app/presentation/screens/cart_screen.dart';
import 'package:otlob_app/presentation/screens/search_screen.dart';
import 'package:otlob_app/shared/components/components.dart';
import 'package:otlob_app/shared/constants/my_colors.dart';


class ShopLayout extends StatelessWidget {
  const ShopLayout({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<ShopCubit>(context)
        ..getUserData()
        ..getCartData()
        ..getFavorites()
        ..getAddresses(),
      child: BlocConsumer<ShopCubit, ShopStates>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = ShopCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              elevation: 0,
              title: const Text(
                'OTLOB',
              ),
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.search,
                  ),
                  onPressed: () {
                    navigateTo(context, SearchScreen());
                  },
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 3),
                  child: buildIconWithNumber(
                      condition: ShopCubit.get(context).totalCarts != 0,
                      icon: Icons.shopping_cart_outlined,
                      number: ShopCubit.get(context).totalCarts,
                      radius: 10,
                      fontSize: 12,
                      alignment: const Alignment(1, -0.8),
                      onPressed: () {
                        navigateTo(context, const CartScreen());
                      }),
                ),
              ],
            ),
            body: cubit.bottomScreens[cubit.currentIndex],
            bottomNavigationBar: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black54, spreadRadius: 1, blurRadius: 3),
                ],
              ),
              child: CurvedNavigationBar(
                items: cubit.bottomItems,
                height: 50,
                color: MyColors.primary,
                animationCurve: Curves.easeInOutCubic,
                buttonBackgroundColor: MyColors.light,
                backgroundColor: MyColors.card,
                index: cubit.currentIndex,
                onTap: (index) => cubit.changeBottomNav(index),
              ),
            ),
          );
        },
      ),
    );
  }
}
