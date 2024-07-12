import 'package:bikeshop/utils/Global%20Folder/glaobal_vars.dart';
import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/views/client/Client%20Home/client_home_page.dart';
import 'package:bikeshop/views/home/home_vars.dart';
import 'package:bikeshop/views/worker/Worker%20Home/worker_home_page.dart';
import 'package:bikeshop/widgets/loading_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../../services/providers/connectitvity_provider.dart';
import '../../services/user_services.dart';
import '../../utils/Global Folder/global_func.dart';
import '../admin/Admin Home/admin_home_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late UserService userService = UserService();
  ValueNotifier isReady = ValueNotifier(false);
  @override
  void initState() {
    super.initState();
    //home main function
    homeMainFunction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:false,
      backgroundColor: bgColor,
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: kIsWeb ? onlineHomeWidget() : mainHomeWidget(),
      ),
    );
  }

  Widget mainHomeWidget() {
    return ValueListenableBuilder(
        valueListenable: isReady,
        builder: (context, value, _) {
          final connectivityProvider =
              Provider.of<ConnectivityProvider>(context);
          connectivityProvider.checkInternet().then(((value) {
            isReady.value = true;
          }));
          if (!isReady.value) {
            return Container(
              color: bgColor,
              child: const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            );
          }

          return homeConsumerWidget();
        });
  }

  Widget homeConsumerWidget() {
    return Consumer<ConnectivityProvider>(
      builder: (context, connectivityProvider, _) {
        isInternetConnected.value = connectivityProvider.isInternetAvailable;
        if (isInternetConnected.value) {
          return onlineHomeWidget();
        } else {
          return offlineHomeWidget();
        }
      },
    );
  }

  Widget onlineHomeWidget() {
    return ValueListenableBuilder(
        valueListenable: isLoadingUser,
        builder: (context, value, _) {
          if (!isLoadingUser.value) {
            if (myUser!.isClient) {
              return const ClientHomePage();
            } else if (!isLoadingUser.value &&
                !myUser!.isClient &&
                !myUser!.isAdmin) {
              return const WorkerHomePage();
            } else {
              return const AdminHomePage();
            }
          }
          return loadingWidget(isLoadingUser);
        });
  }

  Widget offlineHomeWidget() {
    return SizedBox(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          "assets/images/no-internet.png",
          height: 100,
          width: 100,
        ),
        const SizedBox(
          height: 10,
        ),
        Text(
          getText(context, "activateInternet"),
          style: getTextStyleWhiteFjallone(20),
        )
      ],
    ));
  }

  //--Useful Functions Home-----------//
  void setLoadingHome(bool value) {
    setState(() {
      isLoadingUser.value = value;
    });
  }

  void setInternetAvailable(bool value) {
    setState(() {
      isInternetConnected.value = value;
    });
  }

  void homeMainFunction() async {
    setLoadingHome(true);
    if (kIsWeb) {
      setInternetAvailable(true);
      await userService.getUser().then((user) {
        setLoadingHome(false);
      });
    } else {
      await checkInternet().then((internetAvailable) async {
        if (!internetAvailable) {
          setLoadingHome(false);
          setInternetAvailable(false);
        } else {
          setInternetAvailable(true);
          await userService.getUser().then((user) {
            setLoadingHome(false);
          });
        }
      });
    }
  }
}
