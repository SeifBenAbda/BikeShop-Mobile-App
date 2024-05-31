import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:flutter/material.dart';

import '../../auth/login_register_controller.dart';

class WorkerProfile extends StatefulWidget {
  const WorkerProfile({super.key});

  @override
  State<WorkerProfile> createState() => _WorkerProfileState();
}

class _WorkerProfileState extends State<WorkerProfile> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Center(child: logoutBtn()));
  }

  Widget logoutBtn() {
    return GestureDetector(
      onTap: (){
        controller.logout();
      },
      child: Container(
        height: 40,
        width: MediaQuery.of(context).size.width/1.1,
        decoration: getBoxDeco(12, greyColor),
        child: Center(
          child: Text(getText(context, "logout"),style: getTextStyleAbel(16, blueColor),),
        ),
      ),
    );
  }
}
