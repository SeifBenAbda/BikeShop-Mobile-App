import 'package:bikeshop/views/auth/login_register_controller.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../routes/route_names.dart';
import '../services/superbase_service.dart';
import '../utils/helper.dart';
import '../utils/storage/storage.dart';
import '../utils/storage/storage_key.dart';
import '../widgets/birthday_selector.dart';

class AuthController extends GetxController {
  final registerLoading = false.obs;
  final loginLoading = false.obs;

  // * Register Method
  Future<void> register(String email, String password) async {
    Map<String, dynamic> registerData = {
      "email": emailController.text,
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "birthdate": birthDayDate.value.toString(),
      "credits": "0.0",
    };
    registerLoading.value = true;
    try {
      final AuthResponse response = await SupabaseService.client.auth
          .signUp(email: email, password: password, data: registerData);
      print(registerData);
      registerLoading.value = false;

      if (response.user != null) {
        Storage.session.write(StorageKey.session, response.session!.toJson());
        //Get.offAllNamed(RouteNames.home);
      } else {
        showSnackBar("Error", "Something went wrong");
      }
    } on AuthException catch (error) {
      registerLoading.value = false;
      showSnackBar("Error", error.message);
    } catch (error) {
      registerLoading.value = false;
      showSnackBar("Error", "Something went wrong.please try again.");
      print(error);
    }
  }

  // * Login user
  Future<void> login(String email, String password) async {
    loginLoading.value = true;
    try {
      final AuthResponse response = await SupabaseService.client.auth
          .signInWithPassword(email: email, password: password);
      loginLoading.value = false;
      if (response.user != null) {
        Storage.session.write(StorageKey.session, response.session!.toJson());
        Get.offAllNamed(RouteNames.home);
      }
    } on AuthException catch (error) {
      loginLoading.value = false;
      showSnackBar("Error", error.message);
    } catch (error) {
      loginLoading.value = false;
      showSnackBar("Error", "Something went wrong.please try again.");
    }
  }

  //logout
  Future<void> logout() async {
    try {
      await SupabaseService.client.auth.signOut();
      Storage.session.write(StorageKey.session, null);
      print("signout");
    } catch (error) {
      showSnackBar("Error", "Something went wrong.please try again.");
    }
  }
}
