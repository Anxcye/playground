import 'package:flutter/material.dart';

main_in(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("CODERWHY"),
        ),
        body: HomeContent(),
      ),
    );
  }
}

class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Checkbox(
              value: true,
              onChanged: (value) => print("Hello World")),
          Text(
            "同意协议",
            textDirection: TextDirection.ltr,
            style: TextStyle(fontSize: 20),
          )
        ],
      ),
    );
  }
}
