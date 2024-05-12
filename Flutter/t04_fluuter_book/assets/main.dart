import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';
import 'package:flutter/services.dart';

main() {
  runApp(const app());
}

class app extends StatelessWidget {
  const app({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primarySwatch: Colors.purple),
      routes: {
        "tip": (context) {
          return TipRoute(
              text: ModalRoute.of(context)!.settings.arguments.toString());
        }
      },
      home: Content(),
    );
  }
}

class Content extends StatelessWidget {
  const Content({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('hello flutter'),
      ),
      body: SignInWidget(),
    );
  }
}

class SignInWidget extends StatelessWidget {
   SignInWidget({super.key});
  final TextEditingController _controller = TextEditingController();

   void initState() {
     //监听输入改变
     _controller.text = 'hi';
   }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         TextField(
          controller: _controller,
          autofocus: true,
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'user name',
            hintText: 'your user name',
            prefixIcon: Icon(Icons.person),
          ),
        ),
        TextField(
          decoration: const InputDecoration(
            labelText: 'password',
            hintText: 'your password',
            prefixIcon: Icon(Icons.lock),
          ),
          obscureText: true,
            onChanged: (v) {
              print("onChange: $v");
            }
        ),
        ElevatedButton(
          onPressed: () {
            print(_controller.text);
          },
          child: const Text("Go"),
        ),
      ],
    );
  }
}

class SwitchAndCheckBoxTestRoute extends StatefulWidget {
  @override
  _SwitchAndCheckBoxTestRouteState createState() =>
      _SwitchAndCheckBoxTestRouteState();
}

class _SwitchAndCheckBoxTestRouteState
    extends State<SwitchAndCheckBoxTestRoute> {
  var _switchSelected = true; //维护单选开关状态
  var _checkboxSelected = true; //维护复选框状态
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: <Widget>[
          Switch(
            value: _switchSelected, //当前状态
            onChanged: (value) {
              //重新构建页面
              setState(() {
                _switchSelected = value;
              });
            },
          ),
          Checkbox(
            value: _checkboxSelected,
            activeColor: Colors.red, //选中时的颜色
            onChanged: (value) {
              setState(() {
                _checkboxSelected = value!;
              });
            },
          )
        ],
      ),
    );
  }
}

class RandomWordsWidget extends StatelessWidget {
  const RandomWordsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: rootBundle.loadString('assets/config.json'),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Text(snapshot.data.toString());
          } else if (snapshot.hasError) {
            return Text("Error loading config file");
          } else {
            return CircularProgressIndicator();
          }
        });
  }
}

/////// router test //////////////
class TipRoute extends StatelessWidget {
  TipRoute({
    Key? key,
    required this.text, // 接收一个text参数
  }) : super(key: key);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("提示"),
      ),
      body: Padding(
        padding: EdgeInsets.all(18),
        child: Center(
          child: Column(
            children: <Widget>[
              Text(text),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, "我是返回值"),
                child: Text("返回"),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class RouterTestRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () async {
          // 打开`TipRoute`，并等待返回结果
          var result =
              await Navigator.of(context).pushNamed('tip', arguments: 'hi');

          //输出`TipRoute`路由返回结果
          print("路由返回值: $result");
        },
        child: Text("打开提示页"),
      ),
    );
  }
}

/////// manage by parent widget //////////
class TapBoxA2 extends StatefulWidget {
  const TapBoxA2({super.key});

  @override
  State<TapBoxA2> createState() => _TapBoxA2State();
}

class _TapBoxA2State extends State<TapBoxA2> {
  bool _active = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TapBoxB2(
        active: _active,
        onChanged: _handleTapBoxChanged,
      ),
    );
  }

  void _handleTapBoxChanged(bool value) {
    setState(() {
      _active = value;
    });
  }
}

class TapBoxB2 extends StatelessWidget {
  const TapBoxB2({super.key, this.active = false, required this.onChanged});

  final bool active;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTapUp: _handleTapUp,
        onTapDown: _handleTapDown,
        onTap: _handleTap,
        child: Container(
          width: 100,
          height: 100,
          decoration:
              BoxDecoration(color: active ? Colors.lightGreen : Colors.grey),
          child: Center(
            child: Text(
              active ? 'Active' : 'Inactive',
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  void _handleTapUp(TapUpDetails details) {}

  void _handleTapDown(TapDownDetails details) {}

  void _handleTap() {
    onChanged(!active);
  }
}

//////////// manage itself ////////////////

class TapBoxA1 extends StatefulWidget {
  const TapBoxA1({super.key});

  @override
  State<TapBoxA1> createState() => _TapBoxA1State();
}

class _TapBoxA1State extends State<TapBoxA1> {
  bool _active = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: _handletap,
        child: Container(
          width: 100,
          height: 100,
          decoration:
              BoxDecoration(color: _active ? Colors.lightGreen : Colors.grey),
          child: Center(
            child: Text(
              _active ? 'Active' : 'Inactive',
              style: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  _handletap() {
    // print('here');
    setState(() {
      _active = !_active;
    });
  }
}
