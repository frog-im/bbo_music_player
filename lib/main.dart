import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);

  bool wb = true;
  if(!kIsWeb ){
    wb = false;
  }
  runApp(MyApp(wb));
}

class MyApp extends StatelessWidget {
  /**웹인지 모바일인지 확인하기 위한 bool -true는 web -false 는 app은 true*/
  final bool classification;

  const MyApp(this.classification,{super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      home: classification?
      Scaffold(
          backgroundColor: Colors.blue
      ) //
          :
      Scaffold(
          backgroundColor: Colors.blue
      )

    );
  }
}

