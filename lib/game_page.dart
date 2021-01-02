import 'package:flutter/material.dart';
import 'dart:async';

import 'score_board.dart';

enum GameState {
  waiting,
  ready,
  keyword,
  counting,
  calculating,
  result,
  completed,
  error
}

class GamePage extends StatefulWidget {
  final String nickname;

  // constructor에서 required 역할?
  GamePage({@required this.nickname});

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  GameState currState = GameState.waiting;
  String keyword = "error";
  Timer _timer;
  int counting;
  int newPoint = 0;
  int score = 0;
  int currSet = 1;

  final TextStyle _basicStyle = TextStyle(
      fontFamily: "AppleSDGothicNeo",
      fontWeight: FontWeight.w400,
      color: Colors.white,
      fontSize: 18);

  void dispose() {
    if (_timer != null) _timer.cancel();
    super.dispose();
  }

  void completionCount() {
    _timer = Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ScoreBoard()));
    });
  }

  void countDown() {
    const oneSec = const Duration(seconds: 1);
    /* initialize value of 'counting' for next time use */
    counting = 7;
    _timer = new Timer.periodic(oneSec, (timer) async {
      if (counting == 4) {
        setState(() {
          counting--;
          currState = GameState.counting;
        });
      } else if (counting == 0) {
        setState(() {
          timer.cancel();
          timer = null;
          currState = GameState.calculating;
        });
      } else {
        setState(() {
          counting--;
        });
      }
    });
  }

  void resultTimer() {
    counting = 5;
    _timer = new Timer.periodic(Duration(seconds: 1), (timer) {
      if (counting > 0) {
        setState(() {
          counting--;
        });
      } else {
        setState(() {
          _timer.cancel();
          _timer = null;
          if (currSet + 1 > 3) {
            completionCount();
            currState = GameState.completed;
          } else {
            currSet++;
            currState = GameState.waiting;
          }
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    print("resultTimer build");
    Size _size = MediaQuery.of(context).size;
    double _width = _size.width;
    double _height = _size.height;
    print("build");
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Center(
          child: currState != GameState.error
              ? FutureBuilder(
                  /* Deciding widget which tell you what state it is now
                         It depends on 'currState' value. */
                  future: conditionalView(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Stack(
                        children: [
                          if (currState != GameState.counting &&
                              currState != GameState.calculating)
                            background(),
                          snapshot.data,
                          if (currState != GameState.counting) ScoreInfo(),
                        ],
                      );
                    } else {
                      return CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.lime),
                      );
                    }
                  },
                )
              : CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.lime),
                ),
        ));
  }

  Widget background() {
    Size _size = MediaQuery.of(context).size;
    double _width = _size.width;
    double _height = _size.height;
    return Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(170, 0, 0, 0),
              Color.fromARGB(25, 0, 0, 0),
            ]),
      ),
    );
  }

  Future<Widget> conditionalView() async {
    const oneSec = const Duration(seconds: 1);
    if (currState == GameState.waiting) {
      return waitingView();
    } else if (currState == GameState.ready) {
      counting = 2;
      _timer = new Timer.periodic(oneSec, (timer) async {
        if (counting == 0) {
          setState(() {
            timer.cancel();
            timer = null;
            countDown();
            print("setState"); // 출력됨
            currState = GameState.keyword;
            keyword = "keyword";
            print(currState == GameState.keyword); // true
          });
        } else {
          counting--;
        }
      });
      // readyView
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lime),
          ),
          SizedBox(height: 20),
          Text("Waiting all ready..", style: TextStyle(color: Colors.white)),
        ],
      ));
    } else if (currState == GameState.keyword) {
      return keywordView();
    } else if (currState == GameState.counting) {
      return countingView();
    } else if (currState == GameState.calculating) {
      counting = 2;
      _timer = new Timer.periodic(oneSec, (timer) async {
        if (counting == 0) {
          setState(() {
            timer.cancel();
            timer = null;
            newPoint = 60;
            score += newPoint;
            resultTimer();
            currState = GameState.result;
            print(currState);
          });
        } else {
          counting--;
        }
      });
      // calculatingView
      return Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.lime),
          ),
          SizedBox(height: 20),
          Text("calculating..", style: TextStyle(color: Colors.black))
        ],
      ));
    } else if (currState == GameState.result) {
      return ResultView(score: newPoint);
    } else if (currState == GameState.completed) {
      return CompletedView();
    } else {
      return Container();
    }
  }

  Widget waitingView() {
    Size _size = MediaQuery.of(context).size;
    double _width = _size.width;
    double _height = _size.height;
    double _topPadding = MediaQuery.of(context).padding.top;

    return Container(
        width: _width,
        height: _height,
        child: Center(
            child: InkWell(
                onTap: () {
                  if (mounted)
                    setState(() {
                      currState = GameState.ready;
                    });
                },
                splashColor: Color.fromARGB(255, 255, 255, 255),
                child: Container(
                  //width: _width * 0.6,
                  //height: _height * 0.12,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(45),
                      color: Color.fromARGB(255, 255, 255, 255),
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 6.0,
                          color: Colors.black.withOpacity(.5),
                          offset: Offset(5.0, 6.0),
                        ),
                      ]),
                  child: Text("READY",
                      style: _basicStyle.copyWith(
                          fontSize: 25, color: Colors.deepPurple)),
                ))));
  }

  Widget keywordView() {
    Size _size = MediaQuery.of(context).size;
    double _width = _size.width;
    double _height = _size.height;
    double _topPadding = MediaQuery.of(context).padding.top;
    return Center(
      child: Container(
          alignment: Alignment.center,
          child: Text(keyword,
              textAlign: TextAlign.center,
              style: _basicStyle.copyWith(fontSize: 40))),
    );
  }

  Widget countingView() {
    if (counting > 0)
      return Center(
          child: Text("${counting}",
              style: _basicStyle.copyWith(fontSize: 120, color: Colors.black)));
    else
      return Container();
  }

  Widget ScoreInfo() {
    Size _size = MediaQuery.of(context).size;
    double _width = _size.width;
    double _height = _size.height;
    double _topPadding = MediaQuery.of(context).padding.top;
    return Container(
        alignment: Alignment.topCenter,
        margin: EdgeInsets.only(top: _topPadding + 15, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("SCORE : ${score}", style: _basicStyle),
            Text("STAGE ${currSet} / 3", style: _basicStyle)
          ],
        ));
  }

  Widget CompletedView() {
    Size _size = MediaQuery.of(context).size;
    double _width = _size.width;
    double _height = _size.height;
    double _topPadding = MediaQuery.of(context).padding.top;
    return Center(
      child: Container(
          alignment: Alignment.center,
          child: Text("Game Completed",
              textAlign: TextAlign.center,
              style: _basicStyle.copyWith(fontSize: 40))),
    );
  }
}

class ResultView extends StatefulWidget {
  int score;
  ResultView({this.score});
  @override
  _ResultViewState createState() => _ResultViewState();
}

class _ResultViewState extends State<ResultView> {
  final List<String> result = ["Perfect !", "Great !", "Nice !", "Cool !"];

  int resultIndex;

  final TextStyle _resultStyle = TextStyle(
      fontFamily: "AppleSDGothicNeo",
      fontWeight: FontWeight.w600,
      color: Colors.white,
      fontSize: 30);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    double _width = _size.width;
    double _height = _size.height;
    double _topPadding = MediaQuery.of(context).padding.top;

    if (widget.score > 80)
      resultIndex = 0;
    else if (widget.score > 70)
      resultIndex = 1;
    else if (widget.score > 60)
      resultIndex = 2;
    else
      resultIndex = 3;

    return Container(
        width: _width,
        height: _height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              child: Image.asset("assets/images/hanabi.gif", fit: BoxFit.cover),
            ),
            Text(result[resultIndex], style: _resultStyle)
          ],
        ));
  }
}
