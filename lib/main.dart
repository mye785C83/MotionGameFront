import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nicknameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    double _width = _size.width;
    double _height = _size.height;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Stack(
        children: [
          Container(
            // how to align child
            alignment: Alignment.topCenter,
            width: _width,
            child: Image.asset(
              "assets/images/wave2.png",
              width: _width,
              fit: BoxFit.fitWidth
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: _height * 0.35),
                  child: NicknameBox(),
                ),
              ],
            ),
          )
        ],
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Container NicknameBox(){
    Size _size = MediaQuery.of(context).size;
    double _width = _size.width;
    double _height = _size.height;
    return Container(
      width: _width * 0.8,
      padding: EdgeInsets.only(top: 10, bottom: 10),
      height: _height * 0.2,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(40),
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Color.fromARGB(255, 238, 119, 133),
                Color.fromARGB(255, 219, 133, 165),
                Color.fromARGB(255, 200, 130, 180)
              ]
          ),
          boxShadow: [
            BoxShadow(
              blurRadius: 6.0,
              color: Colors.black.withOpacity(.2),
              offset: Offset(5.0, 6.0),
            ),
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Container(
                alignment: Alignment.center,
                child: Text(
                    "Enter a nickname in the game",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "AppleSDGothicNeo",
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontSize: 18
                    )
                ),
              )
          ),
          Container(
              width: _width * 0.7,
              height: _height * 0.1,
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35),
                  color: Colors.white
              ),
              child: Center(
                child: TextField(
                  controller: _nicknameController,
                  decoration: InputDecoration(
                      hintText: "Your Nickname",
                      hintStyle: TextStyle(
                        fontFamily: "AppleSDGothicNeo",
                        fontWeight: FontWeight.w400,
                        color: Color.fromARGB(205, 140, 140, 120),
                        fontSize: 15,
                      ),
                      border: InputBorder.none
                  ),
                  cursorColor: Colors.pink,
                ),
              )
          )
        ],
      ),
    );
  }
}
