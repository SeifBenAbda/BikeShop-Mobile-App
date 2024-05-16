import 'package:flutter/material.dart';

enum DeviceType {
  Mobile,
  Tablet,
  Laptop,
}

class DeviceDetector {
   static DeviceType getDeviceType(BuildContext context) {
    double deviceWidth = MediaQuery.of(context).size.width;

    if (deviceWidth < 600) {
      // If width is less than 600, consider it a mobile device
      return DeviceType.Mobile;
    } else if (deviceWidth >= 600 && deviceWidth < 1200) {
      // If width is between 600 and 1200, consider it a tablet
      return DeviceType.Tablet;
    } else {
      // If width is greater than or equal to 1200, consider it a laptop
      return DeviceType.Laptop;
    }
  }
}

var myDeviceType = ValueNotifier(DeviceType.Mobile);
