import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'storage_key.dart';

class Storage {
  static final GetStorage session = GetStorage();

  // * Read user session
  static dynamic userSession = session.read(StorageKey.session);
}

class StorageLocal {
  bool? isUserClient;


  bool? getIsUserClient(SharedPreferences sp) {
    isUserClient = sp.getBool("isClient");
    return isUserClient;
  }

  void setIsUserClient(bool value, SharedPreferences sp) {
    sp.setBool("isClient", value);
  }
}
