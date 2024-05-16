 import 'package:flutter/material.dart';

import '../utils/Global Folder/global_deco.dart';

Widget loadingWidget(ValueNotifier valueNotifier) {
    return ValueListenableBuilder(
      valueListenable: valueNotifier,
      builder: (context, isLoading, _) {
        return isLoading
            ? Container(
                color: bgColor.withOpacity(0.3),
                child: const Center(
                  child: CircularProgressIndicator(color: Colors.white),
                ),
              )
            : const SizedBox.shrink();
      },
    );
  }