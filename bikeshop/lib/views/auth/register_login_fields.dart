import 'package:bikeshop/views/auth/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:form_validator/form_validator.dart';

import '../../utils/Global Folder/glaobal_vars.dart';
import '../../widgets/auth_input.dart';
import '../../widgets/birthday_selector.dart';
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
                isPasswordField: false,
                fieldWidth: MediaQuery.of(context).size.width / 1.2,
              ),
              const SizedBox(
                height: 10,
              ),
              AuthInput(
                hintText: FlutterI18n.translate(context, "enterPassword"),
                label: FlutterI18n.translate(context, "password"),
                controller: passwordController,
                isPasswordField: true,
                fieldWidth: MediaQuery.of(context).size.width / 1.2,
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
              firstAndLastNameWidget(),
              const SizedBox(
                height: 10,
              ),
              const DateBirthDaySelector(),
              const SizedBox(
                height: 10,
              ),
              AuthInput(
                hintText: FlutterI18n.translate(context, "enterEmail"),
                label: FlutterI18n.translate(context, "email"),
                controller: emailController,
                callback: ValidationBuilder().email().build(),
                isPasswordField: false,
                fieldWidth: MediaQuery.of(context).size.width / 1.2,
              ),
              const SizedBox(
                height: 10,
              ),
              AuthInput(
                hintText: FlutterI18n.translate(context, "enterPassword"),
                label: FlutterI18n.translate(context, "password"),
                controller: passwordController,
                isPasswordField: true,
                fieldWidth: MediaQuery.of(context).size.width / 1.2,
              ),
              const SizedBox(
                height: 10,
              ),
              AuthInput(
                hintText: FlutterI18n.translate(context, "confirmPassword"),
                label: FlutterI18n.translate(context, "confirmPassword"),
                controller: repeatPasswordController,
                isPasswordField: true,
                fieldWidth: MediaQuery.of(context).size.width / 1.2,
              ),
            ],
          );
        });
  }

  Widget firstAndLastNameWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AuthInput(
            hintText: FlutterI18n.translate(context, "firstName"),
            label: FlutterI18n.translate(context, "firstName"),
            controller: firstNameController,
            isPasswordField: false,
            fieldWidth: MediaQuery.of(context).size.width / 2.5,
          ),
          AuthInput(
            hintText: FlutterI18n.translate(context, "lastName"),
            label: FlutterI18n.translate(context, "lastName"),
            controller: lastNameController,
            isPasswordField: false,
            fieldWidth: MediaQuery.of(context).size.width / 2.5,
          ),
        ],
      ),
    );
  }
}
