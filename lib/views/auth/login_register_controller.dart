import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/auth_controller.dart';

final TextEditingController emailController = TextEditingController(text: "");
final TextEditingController passwordController =
    TextEditingController(text: "");

//----Register
final TextEditingController firstNameController =
    TextEditingController(text: "");
final TextEditingController lastNameController =
    TextEditingController(text: "");



final TextEditingController repeatPasswordController =
    TextEditingController(text: "");

final AuthController controller = Get.put(AuthController());
final GlobalKey<FormState> form = GlobalKey<FormState>();
