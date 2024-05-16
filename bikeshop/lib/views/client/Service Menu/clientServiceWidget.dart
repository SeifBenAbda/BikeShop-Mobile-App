import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import '../../../models/client_service_class.dart';
import '../Client Home/client_home_vars.dart';

class ClientServiceWidget extends StatefulWidget {
  final ClientService service;
  final int index; // Index of the service
  const ClientServiceWidget(
      {Key? key, required this.service, required this.index})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ClientServiceWidgetState createState() => _ClientServiceWidgetState();
}

class _ClientServiceWidgetState extends State<ClientServiceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _controller.forward(); // Start the animation
    _animation = Tween<Offset>(
      begin:
          Offset.zero, // Initially animate only if it's not the first service
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return SlideTransition(
          position: _animation,
          child: Container(
            width: MediaQuery.of(context).size.width / 1.4,
            decoration: getBoxDeco(20, blueColor),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                serviceNameAndImage(),
                //const SizedBox(height: 5,),
                serviceDescription(),
                //const SizedBox(height: 5,),
                serviceButton()
              ],
            ),
          ),
        );
      },
    );
  }

  Widget serviceNameAndImage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 2,
          child: AutoSizeText(
            getText(context, widget.service.serviceName),
            style: getTextStyleAbel(18, Colors.white),
          ),
        ),
        Image.asset(
          widget.service.serviceImage,
          height: 45,
          width: 45,
        )
      ],
    );
  }

  Widget serviceDescription() {
    return SizedBox(
      width: MediaQuery.of(context).size.width / 1.6,
      child: AutoSizeText(
        getText(context, widget.service.serviceDescription),
        style: getTextStyleAbel(10, greyColor),
      ),
    );
  }

  Widget serviceButton() {
    return SizedBox(
        width: MediaQuery.of(context).size.width / 1.6,
        child: Row(
          children: [
            const Spacer(), // Add spacer to push the button to the right
            GestureDetector(
              onTap: () {
                goToClientService();
              },
              child: Container(
                //height: 40,
                //width: MediaQuery.of(context).size.width/4,
                padding: const EdgeInsets.all(4),
                margin: const EdgeInsets.all(4),
                decoration: getBoxDeco(10, greyColor),
                child: Center(
                  child: Text(getText(context, widget.service.buttonText),
                      style: getTextStyleAbel(14, bgColor)),
                ),
              ),
            ),
          ],
        ));
  }

  void goToClientService() {
    if (widget.service.serviceRouter == "FIXBIKE") {
      setState(() {
        currentActiveScreenClient.value = widget.service.serviceRouter;
      });
    } else {
      showError(context, getText(context, "serviceUnavailable"));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
