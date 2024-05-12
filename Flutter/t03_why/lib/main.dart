import 'package:flutter/material.dart';

main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HYHomePage(),
    );
  }
}

class HYHomePage extends StatelessWidget {
  const HYHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('widget'),
        backgroundColor: Colors.blue,
      ),
      body: const HYHomeContent(),
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
    return ElevatedButton(

        onPressed: () {
          print('hello');
        },
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.favorite),
            Text("Like"),
          ],
        ));
  }
}

class TextDemo extends StatelessWidget {
  const TextDemo({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Text(
      textScaler: TextScaler.linear(5),
      "Hello World sdfgsdfgsdfls hdfksdfkserype iuvsdjfkajgfweu r webglwebrgnbvf fdghjuwlej",
      style: TextStyle(
        fontSize: 30,
        fontWeight: FontWeight.w700,
      ),
      textAlign: TextAlign.center,
    );
  }
}
