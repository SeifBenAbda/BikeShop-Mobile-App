import 'package:bikeshop/models/shop_service_class.dart';
import 'package:bikeshop/views/client/Fix%20Bicycle/fix_bike_vars.dart';
import 'package:flutter/material.dart';

import '../superbase_service.dart';

class ShopServiceProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  List<ShopService> _shopServices = [];
  List<ShopService> get shopServicesList => _shopServices;

  Future<List<ShopService>> getShopServices() async {
    await Future.delayed(const Duration(seconds: 3));
    List<ShopService> result = [];
    final client = _supabaseService.getSuperbaseClient();

    final response = await client.from('shopservices').select().catchError((e) {
      print(e);
      return [];
    }).timeout(Durations.long2);
    if (response.isEmpty) {
      result = [];
    } else {
      final shopServiceData = response;
      for (final data in shopServiceData) {
        int serviceId = data['serviceid'] as int;
        int serviceIndex = currentOrder!.orderedServices.value
                .indexWhere((service) => service.serviceId == serviceId) ;
        bool serviceExit = serviceIndex != -1;

        ShopService shopService = ShopService(
          serviceId: data['serviceid'] as int,
          serviceName: data['servicename'] as String,
          serviceImage: data['serviceimage'] as String,
          servicePrice: (data['serviceprice'] as num).toDouble(),
          serviceDuration:
              Duration(minutes: data['servicedurationminutes'] as int),
          isServiceAvailable: ValueNotifier(data['isserviceavailable'] as bool),
          serviceDiscount:
              ValueNotifier((data['servicediscount'] as num).toDouble()),
          activeClientsOnService:
              ValueNotifier(data['maxserviceclients'] as int),
          serviceNameGerman: data['de_servicename'] as String,
          isInBasket: serviceExit?ValueNotifier(currentOrder!.orderedServices.value.elementAt(serviceIndex).isInBasket.value):ValueNotifier(false), 
          isFinished: ValueNotifier(false), // Assuming this is correct
        );
        result.add(shopService);
      }

      _shopServices = result;
      notifyListeners();
    }

    return result;
  }
}
