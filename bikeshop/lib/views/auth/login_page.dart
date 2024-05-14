import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import '../../main.dart';
import '../../utils/Global Folder/glaobal_vars.dart';
import 'login_register_controller.dart';
import 'register_login_fields.dart';

var isLoginScreen = ValueNotifier(true);

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _isKeyboardOpen = ValueNotifier(false);

  void login() {
    if (form.currentState!.validate()) {
      if (!controller.loginLoading.value) {
        controller.login(emailController.text, passwordController.text);
      }
    }
  }

  void signup() {
    print("hey");
    if (form.currentState!.validate()) {
      if (!controller.loginLoading.value) {
        controller.register(emailController.text, passwordController.text);
      }
    }
  }

  

  @override
  Widget build(BuildContext context) {
    _isKeyboardOpen.value = isKeyboardOpen(context);
    return Scaffold(
      backgroundColor: bgColor,
      body: Stack(children: [
        Form(
          key: form,
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 50,
                ),
                bikeShopLogoAndText(),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: ScrollConfiguration(
                    behavior: MyBehavior(),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          //topWidgetText(),

                          const LoginRegisterFields(),
                          const SizedBox(
                            height: 20,
                          ),
                          loginRegisterArea(),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ValueListenableBuilder(
            valueListenable: _isKeyboardOpen,
            builder: (context, value, _) {
              return Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: Visibility(
                  visible: !_isKeyboardOpen.value,
                  child: changeLangueWidget(),
                ),
              );
            })
      ]),
    );
  }

  Widget loginRegisterArea() {
    return ValueListenableBuilder(
        valueListenable: isLoginScreen,
        builder: (context, value, _) {
          return Column(
            children: [
              loginRegisterButton(),
              const SizedBox(
                height: 10,
              ),
              loginRegisterText()
            ],
          );
        });
  }

  Widget loginRegisterText() {
    return ValueListenableBuilder(
        valueListenable: isLoginScreen,
        builder: (context, value, _) {
          String buttonText = isLoginScreen.value ? "signup" : "login";
          String buttonTextRich =
              isLoginScreen.value ? "dontHaveAccount" : "alreadyHaveAccount";
          return Text.rich(TextSpan(children: [
            TextSpan(
                text: " ${FlutterI18n.translate(context, buttonText)}",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                recognizer: TapGestureRecognizer()
                  ..onTap = () {
                    setState(() {
                      isLoginScreen.value = !isLoginScreen.value;
                    });
                  }),
          ], text: FlutterI18n.translate(context, buttonTextRich)));
        });
  }

  Widget loginRegisterButton() {
    String buttonText = isLoginScreen.value ? "loginButton" : "signupButton";
    return GestureDetector(
      onTap: () {
        if (isLoginScreen.value) {
          login();
        } else {
          signup();
        }
      },
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width / 1.2,
        decoration: getBoxDeco(10, Colors.white),
        child: Center(
          child: Text(
            controller.loginLoading.value || controller.registerLoading.value
                ? "${FlutterI18n.translate(context, "processing")}..."
                : FlutterI18n.translate(context, buttonText),
            style: getTextStyleFjallone(17, bgColor),
          ),
        ),
      ),
    );
  }

  Widget bikeShopLogoAndText() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: Column(
        children: [
          Image.asset("assets/images/home_logo.png", height: 100, width: 100),
          const SizedBox(height: 10),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.1,
            child: Center(
              child: Text(
                "BIKE SHOP",
                style: getTextStyleWhiteFjallone(25),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget changeLangueWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 1.1,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            languageFlag("en"),
            const SizedBox(
              width: 10,
            ),
            languageFlag("de")
          ],
        ),
      ),
    );
  }

  Widget languageFlag(String language) {
    return GestureDetector(
      onTap: () {
        if (language == "en") {
          changeLanguage("en");
        } else {
          changeLanguage("de");
        }
      },
      child: SizedBox(
        child: Image.asset(
          language == "en"
              ? "assets/images/usa.png"
              : "assets/images/germany.png",
          height: 35,
          width: 35,
        ),
      ),
    );
  }

  Widget topWidgetText() {
    String buttonText = isLoginScreen.value ? "login" : "signup";
    return Text(FlutterI18n.translate(context, buttonText),
        style: getTextStyleWhiteFjallone(25));
  }

  void changeLanguage(String language) {
    Locale newLocale =
        language == "en" ? const Locale('en') : const Locale('de');
    // Set the new locale
    setState(() {
      FlutterI18n.refresh(context, newLocale);
      currentFallBackFile.value = language;
    });
  }

  bool isKeyboardOpen(BuildContext context) {
    final double viewInsetsBottom = MediaQuery.of(context).viewInsets.bottom;
    return viewInsetsBottom > 0;
  }
}
