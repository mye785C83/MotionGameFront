import 'package:flutter/material.dart';
import 'dart:async';
import 'package:permission_handler/permission_handler.dart';

import 'score_board.dart';
import 'game_page.dart';

void main() {
  runApp(MyApp());
}

bool findPartner = false;

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
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _nicknameController = TextEditingController();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    double _width = _size.width;
    double _height = _size.height;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        body: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              // how to align child
              alignment: Alignment.topCenter,
              width: _width,
              child: Image.asset("assets/images/wave2.png",
                  width: _width, fit: BoxFit.fitWidth),
            ),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: _height * 0.35),
                    child: NicknameBox(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(bottom: _height * 0.1),
                    child: Container(
                        child: Column(
                      children: [
                        GestureDetector(
                          onTap: () async {
                            if (_nicknameController.text.isEmpty) {
                              _scaffoldKey.currentState.showSnackBar(SnackBar(
                                  content: Text(
                                      "Enter your nickname for this game.")));
                            } else {
                              await _handleCameraAndMic();
                              showDialog(
                                  context: context,
                                  builder: (context) => Center(
                                      child: CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  Color.fromARGB(
                                                      255, 238, 119, 133)))));
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => FindPartner(
                                      nickname: _nicknameController.text),
                                ),
                              );
                            }
                          },
                          child: _button("Get Started"),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            _nicknameController.clear();
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ScoreBoard()));
                          },
                          child: _button("Ranking"),
                        ),
                      ],
                    )),
                  )
                ],
              ),
            )
          ],
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  Container NicknameBox() {
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
              ]),
          boxShadow: [
            BoxShadow(
              blurRadius: 6.0,
              color: Colors.black.withOpacity(.2),
              offset: Offset(5.0, 6.0),
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: Container(
            alignment: Alignment.center,
            child: Text("Enter a nickname in the game",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "AppleSDGothicNeo",
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                    fontSize: 18)),
          )),
          Container(
              width: _width * 0.7,
              height: _height * 0.1,
              padding: EdgeInsets.only(left: 20, right: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(35), color: Colors.white),
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
                      border: InputBorder.none),
                  cursorColor: Colors.pink,
                ),
              ))
        ],
      ),
    );
  }

  Widget _button(String title) {
    Size _size = MediaQuery.of(context).size;
    double _width = _size.width;
    double _height = _size.height;
    return Container(
        width: _width * 0.55,
        height: _height * 0.08,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            color: Color.fromARGB(255, 250, 250, 250),
            boxShadow: [
              BoxShadow(
                blurRadius: 6.0,
                color: Colors.black.withOpacity(.2),
                offset: Offset(5.0, 6.0),
              ),
            ]),
        child: Center(
            child: Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontFamily: "AppleSDGothicNeo",
                    fontWeight: FontWeight.w400,
                    fontSize: 18,
                    color: Colors.deepPurple))));
  }

  Future<void> _handleCameraAndMic() async {
    await PermissionHandler().requestPermissions(
      [
        PermissionGroup.camera,
        PermissionGroup.microphone,
        PermissionGroup.storage
      ],
    );
  }
}

class FindPartner extends StatefulWidget {
  final String nickname;

  FindPartner({@required this.nickname});

  @override
  _FindPartnerState createState() => _FindPartnerState(nickname);
}

class _FindPartnerState extends State<FindPartner> {
  int counting;
  Timer _timer;
  String _nickname;

  _FindPartnerState(this._nickname);

  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  Future<Widget> findingTimer() async {
    if (findPartner) {
      if(mounted){
        setState(() {
          findPartner = false;
          print("findPartner: ${findPartner}");
        });
      }
      return GamePage(nickname: _nickname);
    } else {
      counting = 2;
      _timer = new Timer.periodic(Duration(seconds: 1), (timer) async {
        if (counting == 0) {
          setState(() {
            timer.cancel();
            timer = null;
            findPartner = true;
          });
        } else {
          setState(() {
            counting--;
          });
        }
      });
      return Scaffold(
          body: Container(
              child: Center(
                  child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lime),
          ),
          SizedBox(height: 20),
          Text("finding partner..", style: TextStyle(color: Colors.black))
        ],
      ))));
    }
  }

  @override
  Widget build(BuildContext context) {
    print("findPartner: ${findPartner}");
    return FutureBuilder(
        future: findingTimer(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data;
          } else {
            return Container(
              width: 0.0,
              height: 0.0,
            );
          }
        });
  }
}
