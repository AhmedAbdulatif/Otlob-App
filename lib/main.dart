
import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'business_logic/cubit/cubit_observer.dart';
import 'business_logic/login_cubit/login_cubit.dart';
import 'business_logic/shop_cubit/shop_cubit.dart';
import 'data/api/dio_helper.dart';
import 'data/cashe_helper.dart';
import 'layout/shop_layout.dart';
import 'presentation/screens/login_screen.dart';
import 'presentation/screens/on_boarding_screen.dart';
import 'shared/constants/constants.dart';
import 'shared/styles/themes.dart';


Widget chooseStartupWidget({required bool onBoarding, String? token}) {
  if (onBoarding) {
    return token != null ? const ShopLayout() : LoginScreen();
  }
  return const OnBoardingScreen();
}

void main() async {
  Bloc.observer = MyBlocObserver();
  WidgetsFlutterBinding.ensureInitialized();
  DioHelper.init();
  await CashHelper.init();
  bool onBoarding = CashHelper.getData(key: 'onBoarding') ?? false;
  token = CashHelper.getData(key: 'token');
  print(token);
  Widget widget = chooseStartupWidget(onBoarding: onBoarding, token: token);

  runApp(MyApp(onBoarding, widget));
}

class MyApp extends StatelessWidget {
  final bool onBoarding;
  final Widget widget;
  const MyApp(this.onBoarding, this.widget, {Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) => LoginCubit(),
        ),
        BlocProvider(
          create: (BuildContext context) => ShopCubit()
          ..getBanners()
            ..getHomeData()
            ..getCategories()
            ..getOrders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: shopTheme,
        home: widget,
        builder: BotToastInit(),
        navigatorObservers: [BotToastNavigatorObserver()],
      ),
    );
  }
}
