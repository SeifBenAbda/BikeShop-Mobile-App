import 'package:bikeshop/views/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:form_validator/form_validator.dart';

import '../../utils/Global Folder/glaobal_vars.dart';
import '../../widgets/auth_input.dart';
import 'login_register_controller.dart';

class LoginRegisterFields extends StatefulWidget {
  const LoginRegisterFields({super.key});

  @override
  State<LoginRegisterFields> createState() => _LoginRegisterFieldsState();
}

class _LoginRegisterFieldsState extends State<LoginRegisterFields> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: isLoginScreen,
        builder: (context, value, _) {
          if (isLoginScreen.value) {
            return loginFields();
          }

          return signupFields();
        });
  }

  Widget loginFields() {
    return ValueListenableBuilder(
        valueListenable: currentFallBackFile,
        builder: (context, value, _) {
          return Column(
            children: [
              AuthInput(
                hintText: FlutterI18n.translate(context, "enterEmail"),
                label: FlutterI18n.translate(context, "email"),
                controller: emailController,
                callback: ValidationBuilder().email().build(),
              ),
              const SizedBox(
                height: 20,
              ),
              AuthInput(
                hintText: FlutterI18n.translate(context, "enterPassword"),
                label: FlutterI18n.translate(context, "password"),
                controller: passwordController,
                isPasswordField: true,
              )
            ],
          );
        });
  }

  Widget signupFields() {
    return ValueListenableBuilder(
        valueListenable: currentFallBackFile,
        builder: (context, value, _) {
          return Column(
            children: [
              AuthInput(
                hintText: FlutterI18n.translate(context, "enterEmail"),
                label: FlutterI18n.translate(context, "email"),
                controller: emailController,
                callback: ValidationBuilder().email().build(),
              ),
              const SizedBox(
                height: 20,
              ),
              AuthInput(
                hintText: FlutterI18n.translate(context, "enterPassword"),
                label: FlutterI18n.translate(context, "password"),
                controller: passwordController,
                isPasswordField: true,
              ),
              const SizedBox(
                height: 20,
              ),
              AuthInput(
                hintText: FlutterI18n.translate(context, "confirmPassword"),
                label: FlutterI18n.translate(context, "confirmPassword"),
                controller: repeatPasswordController,
                isPasswordField: true,
              ),
            ],
          );
        });
  }
}
