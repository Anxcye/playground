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

class HYHomeContent extends StatelessWidget {
  const HYHomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        HYHomeProductionItem("name", "desc",
            "https://pic1.zhimg.com/80/v2-d398d8967abc31aceec2a1693da35a58_1440w.webp"),
        SizedBox(height: 6),
        HYHomeProductionItem("name", "desc",
            "https://pic1.zhimg.com/80/v2-d398d8967abc31aceec2a1693da35a58_1440w.webp"),
        SizedBox(height: 6),
        HYHomeProductionItem("name", "desc",
            "https://pic1.zhimg.com/80/v2-d398d8967abc31aceec2a1693da35a58_1440w.webp")
      ],
    );
  }
}

class HYHomeProductionItem extends StatelessWidget {
  final String name;
  final String desc;
  final String imageUrl;
  final style1 = TextStyle(fontSize: 30);
  final style2 = TextStyle(fontSize: 20);

  HYHomeProductionItem(this.name, this.desc, this.imageUrl);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration:
          BoxDecoration(border: Border.all(width: 5, color: Colors.grey)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: style1,
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            desc,
            style: style2,
          ),
          SizedBox(
            height: 8,
          ),
          Image.network(imageUrl)
        ],
      ),
    );
  }
}
