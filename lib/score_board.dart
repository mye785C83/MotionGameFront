import 'package:flutter/material.dart';

class ScoreBoard extends StatefulWidget {
  @override
  _ScoreBoardState createState() => _ScoreBoardState();
}

class _ScoreBoardState extends State<ScoreBoard> {
  final tableTitleStyle = TextStyle(
      fontFamily: "AppleSDGothicNeo",
      fontWeight: FontWeight.w500,
      color: Colors.black,
      fontSize: 16,
      height: 1.8);

  final tableDetailStyle = TextStyle(
    fontFamily: "AppleSDGothicNeo",
    fontWeight: FontWeight.w300,
    color: Colors.black,
    fontSize: 15,
  );

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    double _width = _size.width;
    double _height = _size.height;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: _width,
        height: _height,
        child: Stack(alignment: Alignment.topCenter, children: [
          Container(
            alignment: Alignment.topCenter,
            width: _width,
            height: _height * 0.3,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft, // start point of the gradation
                    end: Alignment.centerRight, // end point of the gradation
                    colors: [
                  Color.fromARGB(
                      255, 217, 56, 41), // start color of the gradation
                  Color.fromARGB(
                      255, 242, 200, 162) // end color of the gradation
                ])),
          ),
          Positioned(top: _height * 0.15, child: _table()),
          Positioned(bottom: _height * 0.03, child: _back()),
        ]),
      ),
    );
  }

  TableRow dataRow(rank, name, score) {
    BoxDecoration _boxDecoration;
    if (rank % 2 == 1) {
      _boxDecoration = BoxDecoration(color: Color.fromARGB(255, 255, 255, 255));
    } else {
      _boxDecoration = BoxDecoration(color: Color.fromARGB(255, 231, 230, 230));
    }
    return TableRow(decoration: _boxDecoration, children: [
      Text(
        rank.toString(),
        style: tableDetailStyle,
        textAlign: TextAlign.center,
      ),
      Text(
        name,
        style: tableDetailStyle,
        textAlign: TextAlign.center,
      ),
      Text(
        score.toString(),
        style: tableDetailStyle,
        textAlign: TextAlign.center,
      ),
    ]);
  }

  Widget _table() {
    Size _size = MediaQuery.of(context).size;
    double _width = _size.width;
    double _height = _size.height;
    return Container(
      height: _height * 0.7,
      width: _width * 0.85,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              blurRadius: 6.0,
              color: Colors.black.withOpacity(.2),
              offset: Offset(0.0, 6.0),
            ),
          ]),
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(left: 20, top: 23),
              alignment: Alignment.centerLeft,
              child: Text("Score",
                  style: TextStyle(
                      fontFamily: "AppleSDGothicNeo",
                      fontWeight: FontWeight.w500,
                      color: Colors.black,
                      fontSize: 20))),
          Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: FractionColumnWidth(.25),
                1: FractionColumnWidth(.5),
                2: FractionColumnWidth(.25),
              },
              children: [
                TableRow(
                    // Title of each Column
                    decoration: BoxDecoration(
                        color: Color.fromARGB(255, 255, 255, 255)),
                    children: [
                      Text(
                        "Rank",
                        style: tableTitleStyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "Nicknames",
                        style: tableTitleStyle,
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        "score",
                        style: tableTitleStyle,
                        textAlign: TextAlign.center,
                      ),
                    ])
              ]),
          Flexible(
              child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              columnWidths: {
                0: FractionColumnWidth(.25),
                1: FractionColumnWidth(.5),
                2: FractionColumnWidth(.25),
              },
              children: [
                for (int i = 1; i <= 100; i++)
                  dataRow(i, 'name' + i.toString(), i * 7 + 3)
              ],
            ),
          )),
          SizedBox(
            height: 25,
          )
        ],
      ),
    );
  }

  Widget _back() {
    Size _size = MediaQuery.of(context).size;
    double _width = _size.width;
    double _height = _size.height;
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
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
              child: Text("Back",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "AppleSDGothicNeo",
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      color: Colors.deepPurple)))),
    );
  }
}
