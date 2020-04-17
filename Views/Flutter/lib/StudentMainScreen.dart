import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class StudentMainScreen extends StatefulWidget {
  //StudentMainScreen({Key key, this.title}) : super(key: key);

  //final String title;

  @override
  _StudentMainScreenState createState() => new _StudentMainScreenState();
}

class _StudentMainScreenState extends State<StudentMainScreen> {
  int statusCode = 0;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Color(0xff65646a),
      body: new Center(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10.0),
                  //color: Color(0xffebebe8),
                  width: 48.0 * 8,
                  height: 48.0 * 1,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xffebebe8), Color(0xffebebe8)]),
                      borderRadius: BorderRadius.circular(6.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.3),
                            offset: Offset(0.0, 8.0),
                            blurRadius: 8.0)
                      ]),
                  child: (Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Text(" Welcome USER",
                            style: TextStyle(
                                color: Color(0xffcf4411),
                                fontWeight: FontWeight.bold)),

                        ///Here
                      ])),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10.0),
                  //color: Color(0xffebebe8),
                  width: 48.0 * 8,
                  height: 48.0 * 3,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xffebebe8), Color(0xffebebe8)]),
                      borderRadius: BorderRadius.circular(6.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.3),
                            offset: Offset(0.0, 8.0),
                            blurRadius: 8.0)
                      ]),
                  child: (Row(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: new CircularPercentIndicator(
                          radius: 100.0,
                          lineWidth: 12.0,
                          percent: 0.9,
                          center: new Text("General\n Core",
                              style: TextStyle(color: Color(0xffcf4411))),
                          progressColor: Color(0xffcf4411),
                          backgroundColor: Color(0xffebebe8),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: new CircularPercentIndicator(
                          radius: 100.0,
                          lineWidth: 12.0,
                          percent: 0.7,
                          center: new Text("Major\n Specific",
                              style: TextStyle(color: Color(0xffcf4411))),
                          progressColor: Color(0xffcf4411),
                          backgroundColor: Color(0xffebebe8),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(10),
                        child: new CircularPercentIndicator(
                          radius: 100.0,
                          lineWidth: 12.0,
                          percent: 0.8,
                          center: new Text("Supported\n Courses",
                              style: TextStyle(color: Color(0xffcf4411))),
                          progressColor: Color(0xffcf4411),
                          backgroundColor: Color(0xffebebe8),
                        ),
                      ),
                    ],
                  )),
                ),
              ],
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(10.0),
                  //color: Color(0xffebebe8),
                  width: 48.0 * 8,
                  height: 48.0 * 8,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          colors: [Color(0xffebebe8), Color(0xffebebe8)]),
                      borderRadius: BorderRadius.circular(6.0),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(.3),
                            offset: Offset(0.0, 8.0),
                            blurRadius: 8.0)
                      ]),
                  child: (Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                    FloatingActionButton(onPressed: null,
                    child: Icon(Icons.add),
                    backgroundColor: Color(0xffcf4411),)

                    ///Here
                  ])),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
