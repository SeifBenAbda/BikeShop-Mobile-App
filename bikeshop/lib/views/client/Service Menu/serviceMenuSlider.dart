import 'dart:async';

import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:flutter/material.dart';
import 'package:bikeshop/views/client/Service%20Menu/clientServiceWidget.dart';

import '../../../models/client_service_class.dart';


class ShopServiceSlider extends StatefulWidget {
 

  const ShopServiceSlider({Key? key}) : super(key: key);

  @override
  _ShopServiceSliderState createState() => _ShopServiceSliderState();
}

class _ShopServiceSliderState extends State<ShopServiceSlider> {
  late ScrollController _scrollController;
  late Timer _timer;
  bool _isSliding = true;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _startAutoSlide();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void _startAutoSlide() {
  _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
    if (_isSliding) {
      final currentIndex = (_scrollController.position.pixels / (MediaQuery.of(context).size.width / 1.4)).round();
      final nextIndex = (currentIndex + 1) % listClientServices.length;
     
      final nextPosition = nextIndex * (MediaQuery.of(context).size.width / 1.4);
      

      _scrollController.animateTo(
        nextPosition,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
      );
    }
  });
}



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width / 1.1,
          child: Text(getText(context, "ourServices"),style: getTextStyleAbel(20, Colors.white),), // Your text widget here
        ),
        const SizedBox(height: 10),
        sliderMainWidget(),
      ],
    );
  }

  Widget sliderMainWidget() {
    return GestureDetector(
      onLongPressStart: (_) {
        setState(() {
          _isSliding = false;
        });
      },
      onLongPressEnd: (_) {
        setState(() {
          _isSliding = true;
        });
      },
      child: SizedBox(
        height: 200,
        child: Padding(
          padding: const EdgeInsets.only(left:8.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            itemCount: listClientServices.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClientServiceWidget(
                  service: listClientServices[index],
                  index: index,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
