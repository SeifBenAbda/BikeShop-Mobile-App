import 'package:bikeshop/services/user_services.dart';
import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:bikeshop/views/client/Buy%20Accessories/accessories_page.dart';
import 'package:bikeshop/views/client/Buy_Sell_Bicycles/buy_sell_page.dart';
import 'package:bikeshop/views/client/Fix%20Bicycle/fix_bike_page.dart';
import 'package:bikeshop/views/client/Order%20Tracking/order_tracking_client.dart';
import 'package:flutter/material.dart';
import '../../../models/client_service_class.dart';
import '../Fix Bicycle/fix_bike_vars.dart';
import '../Profile/client_profile_page.dart';
import '../../../widgets/ItemsSliderWidget.dart';
import '../../../widgets/bottom_nav.dart';
import '../Service Menu/clientServiceWidget.dart';
import 'client_home_fun.dart';
import 'client_home_vars.dart';
import 'web_client_home_widgets.dart';

class ClientHomePage extends StatefulWidget {
  const ClientHomePage({super.key});
  @override
  State<ClientHomePage> createState() => _ClientHomePageState();
}

class _ClientHomePageState extends State<ClientHomePage> {
  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: isSmallScreen(context)
            ? BottomNavigation(
                navigateNavBarFn: navigateClient,
                navigationOptions: clientHomeOptions,
                activeScreenNotifer: currentActiveScreenClient,
              )
            : null,
        body: ValueListenableBuilder(
            valueListenable: currentActiveScreenClient,
            builder: (context, value, _) {
              return getClientScreen();
            }));
  }

  Widget getClientScreen() {
    switch (currentActiveScreenClient.value) {
      case "H":
        return homePageMain();
      case "FIXBIKE":
        return const FixBikePage();
      case "BUYACCESSORY":
        return const AccessoriesPage();
      case "BUYANDSELL":
        return const BuyAndSellPage();
      case "C_PROFILE":
        return const ClientProfilePage();
      case "C_ORDERS":
        return const OrderTrackingClient();
      default:
        return homePageMain();
    }
  }

  Widget homePageMain() {
    return Column(
      children: [
        (isSmallScreen(context))
            ? topClientHomePageWidgetMobile()
            : topClientHomePageWidgetWeb(context),
        const SizedBox(
          height: 40,
        ),
        isSmallScreen(context)
            ? sliderWidget()
            : Container()
      ],
    );
  }

  Widget sliderWidget() {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.1,
          child: Text(
            getText(context, "ourServices"),
            style: getTextStyleAbel(20, Colors.white),
          ), // Your text widget here
        ),
        const SizedBox(height: 10),
        ListSlider(
                list: listClientServices,
                slidingWidget: slidingClientServicesWidget, sliderContentWidth: MediaQuery.of(context).size.width / 1.4, sliderContentHeight: 200,
              )
      ],
    );
  }

  Widget topClientHomePageWidgetMobile() {
    //this widget represents "Hello User" and Avatar
    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width / 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(
                width: 10,
              ),
              clientNameWidget(),
              clientAvatar(),
              const SizedBox(
                width: 5,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget clientNameWidget() {
    late String username = getClientName(
        '${myUser!.firstName.substring(0, 1).toUpperCase()}${myUser!.firstName.substring(1)}');
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.35,
      child: Row(
        children: [
          Text("${getText(context, "hello")}, ",
              style: getTextStyleWhiteFjallone(25)),
          const SizedBox(
            width: 2,
          ),
          Expanded(
              child: Text(
            username,
            style: getTextStyleFjalloneBold(25, Colors.white),
            overflow: TextOverflow.fade,
          ))
        ],
      ),
    );
  }

  Widget clientAvatar() {
    return CircleAvatar(
      radius: 30,
      backgroundColor: optionConColor,
      child: Center(
          child: Image.asset(
        "assets/images/user_avatar.png",
        height: 40,
        width: 40,
      )),
    );
  }

  Widget slidingClientServicesWidget(int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ClientServiceWidget(
        service: listClientServices[index],
        index: index,
      ),
    );
  }

  void navigateClient(int optionIndex) {
    String serviceQuickAccess =
        clientHomeOptions.elementAt(optionIndex).optionQuickAcess!;

    setState(() {
      currentActiveScreenClient.value = serviceQuickAccess;
      isBasketBikeFixActive.value = false;
    });
  }
}
