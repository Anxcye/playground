import 'package:flutter/material.dart';

main() {
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyContent();
  }
}

class MyContent extends StatelessWidget {
  const MyContent({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ScaffoldRoute(),
    );
  }
}

class ScaffoldRoute extends StatefulWidget {
  const ScaffoldRoute({super.key});

  @override
  State<ScaffoldRoute> createState() => _ScaffoldRouteState();
}

class _ScaffoldRouteState extends State<ScaffoldRoute> {
  int _selectIndex = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reader'),
        // leading: Icon(Icons.home),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.share)),
        ],
      ),
      drawer: MyDrawer(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), label: 'business'),
          BottomNavigationBarItem(icon: Icon(Icons.school), label: 'school'),
        ],
        currentIndex: _selectIndex,
        fixedColor: Colors.blue,
        onTap: _onItemTapped,
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _onAdd,
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectIndex = index;
    });
  }

  void _onAdd() {}
}

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      Icons.verified_user,
                      size: 60,
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    'Anx',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                ],
              ),
            ),
            Expanded(child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.add),
                  title: Text('Add account'),
                ),
                ListTile(
                  leading: Icon(Icons.settings),
                  title: Text('settings'),
                ),

              ],
            ))
          ],
        ),
      ),
    );
  }
}
