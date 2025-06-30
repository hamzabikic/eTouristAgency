import 'package:etouristagency_mobile/config/auth_config.dart';
import 'package:etouristagency_mobile/screens/login_screen.dart';
import 'package:etouristagency_mobile/screens/master_screen.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreen("Moj nalog", Column(
      children: [
      ElevatedButton(onPressed: (){
        AuthConfig.clearData();
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=> LoginScreen()));
      }, child: Text("Odjavi se"))
    ],));
  }
}