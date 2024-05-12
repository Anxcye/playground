import 'package:flutter/material.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HYHomePage(),
    );
  }
}

class HYHomePage extends StatelessWidget {
  const HYHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("products"), backgroundColor: Colors.blue),
      body: HYHomeContent(),
    );
  }
}

class HYHomeContent extends StatefulWidget {
  const HYHomeContent({super.key});

  @override
  State<HYHomeContent> createState() => _HYHomeContentState();
}

class _HYHomeContentState extends State<HYHomeContent> {

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text("hello")
      ],
    );
  }

}
