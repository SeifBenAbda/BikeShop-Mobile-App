import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:flutter/material.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';

import 'client_home_vars.dart';

class ClientHomeOptions {
  String? optionName;
  String? optionQuickAcess;
  IconData? optionIcon;
  RiveIcon? optionRivIcon;

  ClientHomeOptions({
    required this.optionName,
    required this.optionQuickAcess,
    required this.optionIcon,
    required this.optionRivIcon,
  });
}

class BottomNavigationClient extends StatefulWidget {
  const BottomNavigationClient({super.key});

  @override
  State<BottomNavigationClient> createState() => _BottomNavigationClientState();
}

class _BottomNavigationClientState extends State<BottomNavigationClient> {
  List<ClientHomeOptions> clientHomeOptions = [
    ClientHomeOptions(
        optionName: 'home',
        optionQuickAcess: "H",
        optionIcon: Icons.home_outlined,
        optionRivIcon: RiveIcon.home),
    ClientHomeOptions(
        optionName: "orders",
        optionQuickAcess: "C_ORDERS",
        optionIcon: Icons.receipt_long_outlined,
        optionRivIcon: RiveIcon.menuDots),
    ClientHomeOptions(
        optionName: "profile",
        optionQuickAcess: "C_PROFILE",
        optionIcon: Icons.person_3_outlined,
        optionRivIcon: RiveIcon.profile)
  ];

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: currentActiveScreenClient,
        builder: (context, value, _) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                height: 80,
                padding: const EdgeInsets.only(
                    left: 20, right: 20, top: 12, bottom: 12),
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: getBoxDecoShadowed(24, blueColor),
                child: Center(child: navBarOptions()),
              ),
            ),
          );
        });
  }

  Widget navBarOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        for (int i = 0; i < clientHomeOptions.length; i++) optionWidget(i)
      ],
    );
  }

  Widget optionWidget(int optionIndex) {
    return GestureDetector(
      onTap: () {
        navigateClient(optionIndex);
      },
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            Icon(
              clientHomeOptions.elementAt(optionIndex).optionIcon,
              color: isActiveOption(optionIndex) ? blueColor1 : greyColor2,
              size: 30,
            ),
            const SizedBox(
              height: 4,
            ),
            Center(
              child: Text(
                getText(context,
                    clientHomeOptions.elementAt(optionIndex).optionName!),
                style: getTextStyleAbel(
                    12, isActiveOption(optionIndex) ? blueColor1 : greyColor2),
              ),
            )
          ],
        ),
      ),
    );
  }

  bool isActiveOption(int optionIndex) {
    return currentActiveScreenClient.value ==
        clientHomeOptions.elementAt(optionIndex).optionQuickAcess!;
  }

  void navigateClient(int optionIndex) {
    if (clientHomeOptions.elementAt(optionIndex).optionQuickAcess == "H") {
      setState(() {
        currentActiveScreenClient.value =
            clientHomeOptions.elementAt(optionIndex).optionQuickAcess!;
      });
    } else {
      showError(context, getText(context, "serviceUnavailable"));
    }
  }
}
