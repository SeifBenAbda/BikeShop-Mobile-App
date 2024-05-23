import 'package:bikeshop/services/user_services.dart';
import 'package:bikeshop/utils/Global%20Folder/glaobal_vars.dart';
import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:bikeshop/views/auth/login_register_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:intl/intl.dart';
import 'client_profile_field.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: currentFallBackFile,
        builder: (context, value, _) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              const SizedBox(
                height: 40,
              ),
              profileTopContainer(),
              const SizedBox(
                height: 20,
              ),
              Expanded(
                child: Column(
                  children: [
                    firstAndLastName(),
                    const SizedBox(
                      height: 15,
                    ),
                    emailAdressWidget(),
                    const SizedBox(
                      height: 15,
                    ),
                    dateOfBirthday(),
                    const SizedBox(
                      height: 15,
                    ),
                    currentLanguageWidget(),
                    const SizedBox(
                      height: 15,
                    ),
                    logoutButtonWidet()
                  ],
                ),
              )
            ]),
          );
        });
  }

  Widget profileTopContainer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const SizedBox(
            width: 20,
          ),
          const Spacer(),
          Text(
            getText(context, "myProfile").toUpperCase(),
            style: getTextStyleAbel(25, greyColor),
          ),
          const Spacer(),
          Image.asset(
            "assets/images/user_avatar.png",
            height: 40,
            width: 40,
          )
        ],
      ),
    );
  }

  Widget firstAndLastName() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClientProfileField(
              label: getText(context, "firstName"),
              fieldValue: myUser!.firstName,
              isEnabled: false,
              isObscured: false,
              controller: null,
              fieldWidth: MediaQuery.of(context).size.width / 2.5),
          ClientProfileField(
              label: getText(context, "lastName"),
              fieldValue: myUser!.lastName,
              isEnabled: false,
              isObscured: false,
              controller: null,
              fieldWidth: MediaQuery.of(context).size.width / 2.5),
        ],
      ),
    );
  }

  Widget emailAdressWidget() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.1,
      child: ClientProfileField(
          label: getText(context, "email"),
          fieldValue: myUser!.email,
          isEnabled: false,
          isObscured: false,
          controller: null,
          fieldWidth: MediaQuery.of(context).size.width / 1.1),
    );
  }

  Widget dateOfBirthday() {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 1.1,
        child: ValueListenableBuilder(
            valueListenable: currentFallBackFile,
            builder: (context, value, _) {
              return ClientProfileField(
                  label: getText(context, "dateOfBirth"),
                  fieldValue: formatDate(myUser!.birthDate, value),
                  isEnabled: false,
                  isObscured: false,
                  controller: null,
                  fieldWidth: MediaQuery.of(context).size.width / 1.1);
            }));
  }

  Widget currentLanguageWidget() {
    return InkWell(
      highlightColor: Colors.transparent,
      hoverColor: Colors.transparent,
      splashColor: Colors.transparent,
      onTap: () {
        changeLanguage();
      },
      child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width / 1.1,
        decoration: getBoxDeco(10, blueColor),
        child: languageWidget(),
      ),
    );
  }

  Widget languageWidget() {
    bool isGerman = currentFallBackFile.value == "de";
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          isGerman ? "Deutsch" : "English",
          style: getTextStyleWhiteFjallone(15),
        ),
        const SizedBox(
          width: 10,
        ),
        Image.asset(
          isGerman ? "assets/images/germany.png" : "assets/images/usa.png",
          height: 30,
          width: 30,
        )
      ],
    );
  }

  Widget logoutButtonWidet() {
    return GestureDetector(
      onTap: () {
        controller.logout();
      },
      child: Container(
        width: MediaQuery.of(context).size.width / 1.1,
        height: 50,
        decoration: getBoxDeco(12, redColor),
        child: Center(
          child: Text(
            getText(context, "logout"),
            style: getTextStyleAbel(16, greyColor),
          ),
        ),
      ),
    );
  }

  //---useful functions
  String formatDate(DateTime date, String lang) {
    String format = lang == "de" ? "dd.MM.yyyy" : "dd/MM/yyyy";
    return DateFormat(format).format(date);
  }

  void changeLanguage() async {
    // setLoadingClient(true);
    bool isGerman = currentFallBackFile.value == "de";
    String language = isGerman ? "en" : "de";
    Locale newLocale =
        language == "en" ? const Locale('en') : const Locale('de');
    // Set the new locale

    await FlutterI18n.refresh(context, newLocale);
    setState(() {
      currentFallBackFile.value = language;
    });

    //setLoadingClient(false);
  }
}
