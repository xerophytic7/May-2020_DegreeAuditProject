import 'dart:convert';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:seniordesign/globals/globals.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

final storage = new FlutterSecureStorage();

String firstname = "USER";
String lastname = "USER";
String email = "USEREMAIL";
double gpa = 0.0;
String catalogyear = "####-####";
String classification = "Undergrad";
int hours = 0;
int advancedhours = 0;
int advancedcshours = 0;

Future<String> StudentInfo() async {
  //String username,password,fn,ln,id;
  String value = await storage.read(key: "token");
  print("This is the supposed Token $value");
  final response = await http.get(
    "${address}/MyInfo",
    headers: {HttpHeaders.authorizationHeader: "Bearer ${value}"},
  );

  Map<String, dynamic> data = json.decode(response.body);
  print("return the JSON of info ==> $data");

  firstname       = data["FirstName"];
  lastname        = data["LastName"];
  email           = data["Email"];
  gpa             = data["GPA"];
  catalogyear     = data["CatalogYear"];
  classification  = data["Classification"];
  hours           = data["Hours"];
  advancedhours   = data["AdvancedHours"];
  advancedcshours = data["AdvancedCsHours"];

}

class AdminMainScreen extends StatefulWidget {
  //AdminMainScreen({Key key, this.title}) : super(key: key);

  //final String title;

  @override
  _AdminMainScreenState createState() => new _AdminMainScreenState();
}

class _AdminMainScreenState extends State<AdminMainScreen> {
  int statusCode = 0;
  @override
  Widget build(BuildContext context) {
    StudentInfo();
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
                        new Text(" Welcome! $firstname $lastname",
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
                          center: new Text("10%",
                              style: TextStyle(
                                  color: Color(0xffcf4411), fontSize: 30)),
                          progressColor: Color(0xffcf4411),
                          backgroundColor: Color(0xffebebe8),
                        ),
                      ),
                      Column(children: [
                        Text("10%",
                            style: TextStyle(
                                color: Color(0xffcf4411), fontSize: 30)),
                      ]),
                      Column(children: [
                        Text("10%",
                            style: TextStyle(
                                color: Color(0xffcf4411), fontSize: 30)),
                      ]),
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
                  height: 48.0 * 9,
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
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
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
                          ],
                        ),
                        Row(
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
                          ],
                        ),
                        Row(
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
                          ],
                        ),

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
