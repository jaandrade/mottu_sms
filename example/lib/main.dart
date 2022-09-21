import 'package:flutter/material.dart';
import 'package:sms_plugin_example/sms_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SmsWidget(),
      title: 'Mottu Sms',
      theme: ThemeData(
        backgroundColor: const Color(0xff1A1C1D),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.green,
        useMaterial3: true,
        brightness: Brightness.light,
      ),
    );
  }
}
