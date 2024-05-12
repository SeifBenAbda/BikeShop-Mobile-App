import 'package:bikeshop/utils/theme/theme.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';
import '../../routes/route_names.dart';
import '../../utils/styles/authButton_style.dart';
import '../../widgets/auth_input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController(text: "");
  final TextEditingController passwordController =
      TextEditingController(text: "");
  final AuthController controller = Get.put(AuthController());
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("heyy");
  }

  void login() {
    if (_form.currentState!.validate()) {
      if (!controller.loginLoading.value) {
        controller.login(emailController.text, passwordController.text);
      }
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
          child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Form(
            key: _form,
            child: Column(
              children: [
                //image here
                const SizedBox(
                  height: 10,
                ),
                const Align(
                  alignment: Alignment.topLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                        ),
                      ),
                      Text("Welcome back,"),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                AuthInput(
                  hintText: "Enter your email",
                  label: "Email",
                  controller: emailController,
                  callback: ValidationBuilder().email().build(),
                ),
                const SizedBox(
                  height: 20,
                ),
                AuthInput(
                  hintText: "Enter your password",
                  label: "Password",
                  controller: passwordController,
                  isPasswordField: true,
                ),
                const SizedBox(
                  height: 20,
                ),
                Obx(
                  () => ElevatedButton(
                    style: authButtonStyle(
                      controller.loginLoading.value
                          ? Colors.white.withOpacity(0.6)
                          : Colors.white,
                      Colors.black,
                    ),
                    onPressed: login,
                    child: Text(controller.loginLoading.value
                        ? "Processing..."
                        : "Submit"),
                  ),
                ),
                const SizedBox(height: 20),
                Text.rich(TextSpan(children: [
                  TextSpan(
                      text: " Sign up",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () => Get.toNamed(RouteNames.register)),
                ], text: "Don't have an account ?"))
              ],
            ),
          ),
        ),
      )),
    );
  }
}
