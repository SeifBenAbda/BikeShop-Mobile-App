import 'package:bikeshop/utils/Global%20Folder/global_deco.dart';
import 'package:bikeshop/utils/Global%20Folder/global_func.dart';
import 'package:flutter/material.dart';

class ClientProfilePage extends StatefulWidget {
  const ClientProfilePage({super.key});

  @override
  State<ClientProfilePage> createState() => _ClientProfilePageState();
}

class _ClientProfilePageState extends State<ClientProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 40,),
        profileTopContainer()
        ],
    );
  }

  Widget profileTopContainer() {
    return SizedBox(
      width: MediaQuery.of(context).size.width/1.1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Spacer(),
          const Spacer(),
          Text(getText(context, "myProfile").toUpperCase(),style: getTextStyleAbel(25, greyColor),),
          const Spacer(),
          Image.asset("assets/images/user_avatar.png",height: 40,width: 40,)
        ],
      ),
    );
  }
}
