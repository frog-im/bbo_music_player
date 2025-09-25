import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class main_app_ui extends StatefulWidget {
  const main_app_ui(/*{super.key}*/); // 생성자

  @override
  State<main_app_ui> createState() => _myUI();
}

class _myUI extends State<main_app_ui> {

  void _increment() {

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: _increment,
          child: const Text("증가"),
        ),
      ],
    );
  }
}
