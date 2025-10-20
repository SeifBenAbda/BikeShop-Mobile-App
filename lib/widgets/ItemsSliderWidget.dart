import 'dart:async';
import 'package:flutter/material.dart';


class ListSlider extends StatefulWidget {
  final List list;
  final Widget Function(int) slidingWidget;
  final double sliderContentWidth;
  final double sliderContentHeight;

  const ListSlider({Key? key, required this.list, required this.slidingWidget, required this.sliderContentWidth, required this.sliderContentHeight})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _ListSliderState createState() => _ListSliderState();
}

class _ListSliderState extends State<ListSlider> {
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
    _timer = Timer.periodic(const Duration(seconds: 6), (timer) {
      if (_isSliding) {
        final currentIndex = (_scrollController.position.pixels /
                (widget.sliderContentWidth))
            .round();
        final nextIndex = (currentIndex + 1) % widget.list.length;

        final nextPosition =
            nextIndex * (widget.sliderContentWidth);

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
    return sliderMainWidget();
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
        height: widget.sliderContentHeight,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            itemCount: widget.list.length,
            itemBuilder: (context, index) {
              return widget.slidingWidget(index);
            },
          ),
        ),
      ),
    );
  }
}
