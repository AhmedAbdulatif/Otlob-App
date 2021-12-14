import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otlob_app/business_logic/login_cubit/login_cubit.dart';
import 'package:otlob_app/business_logic/login_cubit/login_states.dart';
import 'package:otlob_app/business_logic/shop_cubit/shop_cubit.dart';
import 'package:otlob_app/business_logic/shop_cubit/shop_states.dart';
import 'package:otlob_app/shared/components/components.dart';
import 'package:otlob_app/shared/constants/my_colors.dart';


class MyAccountScreen extends StatelessWidget {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  MyAccountScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ShopCubit, ShopStates>(listener: (context, state) {
      if (state is UpdateProfileSuccessState) {
        if (state.loginModel.status) {
          showToast(
              msg: state.loginModel.message!,
              state: ToastStates.SUCCESS,
              seconds: 3);
        } else {
          showToast(
            msg: state.loginModel.message!,
            state: ToastStates.ERROR,
            seconds: 3,
          );
        }
      }
    }, builder: (context, state) {
      var userModel = ShopCubit.get(context).userModel;

      nameController.text = userModel!.data!.name;
      emailController.text = userModel.data!.email;
      phoneController.text = userModel.data!.phone;
      return Scaffold(
        appBar: AppBar(
          leadingWidth: 130,
          leading: backButton(context),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsetsDirectional.all(20),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Account",
                    style: TextStyle(
                      fontSize: 30,
                      color: MyColors.light,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Cairo",
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  defaultFormField(
                    controller: nameController,
                    keyboardType: TextInputType.name,
                    prefixIcon: Icons.account_circle,
                    hint: 'Name',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  defaultFormField(
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
                    validate: (value) {
                      return value!.isEmpty
                          ? 'Please enter a valid email address. '
                          : null;
                    },
                    prefixIcon: Icons.email_outlined,
                    hint: 'Email Address',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  defaultFormField(
                    controller: phoneController,
                    keyboardType: TextInputType.phone,
                    validate: (value) {
                      if (value!.isEmpty) {
                        return 'Please fill this field';
                      } else if (value.length < 11) {
                        return 'Please enter a valid phone number';
                      }
                      return null;
                    },
                    prefixIcon: Icons.phone_android_outlined,
                    hint: 'Phone',
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  ConditionalBuilder(
                    condition: state is! UpdateProfileLoadingState,
                    builder: (context) => primaryButton(
                        text: "Update Profile",
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            ShopCubit.get(context).updateProfile(
                                name: nameController.text,
                                email: emailController.text,
                                phone: phoneController.text);
                          }
                        }),
                    fallback: (context) => buildProgressIndicator(),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  ConditionalBuilder(
                    condition: state is! LogoutLoadingState,
                    builder: (context) => primaryButton(
                        text: "Sign Out",
                        onPressed: () {
                          LoginCubit.get(context).userLogout();
                        }),
                    fallback: (context) => buildProgressIndicator(),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
