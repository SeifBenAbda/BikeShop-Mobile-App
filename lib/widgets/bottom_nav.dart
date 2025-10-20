import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:flutter/material.dart';
import 'package:rive_animated_icon/rive_animated_icon.dart';
class NavOptions {
  String? optionName;
  String? optionQuickAcess;
  IconData? optionIcon;
  RiveIcon? optionRivIcon;

  NavOptions({
    required this.optionName,
    required this.optionQuickAcess,
    required this.optionIcon,
    required this.optionRivIcon,
  });
}

var clickedOptionIndex = ValueNotifier(0);

class BottomNavigation extends StatefulWidget {
  final Function(int optionIndex) navigateNavBarFn;
  final List<NavOptions> navigationOptions;
  final ValueNotifier activeScreenNotifer;
  const BottomNavigation(
      {super.key,
      required this.navigateNavBarFn,
      required this.navigationOptions,
      required this.activeScreenNotifer});

  @override
  State<BottomNavigation> createState() => _BottomNavigationClientState();
}

class _BottomNavigationClientState extends State<BottomNavigation> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: widget.activeScreenNotifer,
        builder: (context, value, _) {
          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                height: 80,
                padding: const EdgeInsets.only(
                    left: 15, right: 15, top: 12, bottom: 12),
                margin: const EdgeInsets.symmetric(horizontal: 30),
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
        for (int i = 0; i < widget.navigationOptions.length; i++)
          optionWidget(i)
      ],
    );
  }

  Widget optionWidget(int optionIndex) {
    return GestureDetector(
      onTap: () {
        widget.navigateNavBarFn(optionIndex);
      },
      child: SizedBox(
        width: 100,
        child: Column(
          children: [
            Icon(
              widget.navigationOptions.elementAt(optionIndex).optionIcon,
              color: isActiveOption(optionIndex) ? blueColor1 : greyColor2,
              size: 30,
            ),
            const SizedBox(
              height: 4,
            ),
            Center(
              child: Text(
                getText(
                    context,
                    widget.navigationOptions
                        .elementAt(optionIndex)
                        .optionName!),
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
    return widget.activeScreenNotifer.value ==
        widget.navigationOptions.elementAt(optionIndex).optionQuickAcess!;
  }
}
