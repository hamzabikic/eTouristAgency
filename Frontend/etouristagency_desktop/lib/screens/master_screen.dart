import 'package:flutter/material.dart';

class MasterScreen extends StatefulWidget {
  late final Widget body;
  MasterScreen(this.body, {super.key});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Column(children: [
        Container(color: Color.fromRGBO(0,120,215,1),
        height:70,
        child:Row(children: [
          
        ],)),
        Expanded(
          child: SingleChildScrollView(child: widget.body))
      ],)
    );
  }
}