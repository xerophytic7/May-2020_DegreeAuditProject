import 'dart:convert';
import 'dart:ffi';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nice_button/NiceButton.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:seniordesign/globals/globals.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:seniordesign/studentpages/AddAClass.dart';

final storage = new FlutterSecureStorage();

class Student {
  final String firstname;
  final String lastname;
  final String email;
  final double gpa;
  final String catalogyear;
  final String classification;
  final int hours;
  final int advancedhours;
  final int advancedcshours;

  Student(
      this.firstname,
      this.lastname,
      this.email,
      this.gpa,
      this.catalogyear,
      this.classification,
      this.hours,
      this.advancedcshours,
      this.advancedhours);
}

Future<Student> studentInfo() async {
  //String username,password,fn,ln,id;
  String value = await storage.read(key: "token");
  print("This is the supposed Token $value");
  final response = await http.get(
    "$address/MyInfo",
    headers: {HttpHeaders.authorizationHeader: "Bearer $value"},
  );

  var data = json.decode(response.body);

  print("return the JSON of info ==> $data");

  Student student = Student(
      data["FirstName"],
      data["LastName"],
      data["Email"],
      data["GPA"],
      data["CatalogYear"],
      data["Classification"],
      data["Hours"],
      data["AdvancedCsHours"],
      data["AdvancedHours"]);

  return student;
}

class StudentMainScreenMinor extends StatefulWidget {
  //StudentMainScreenMinor({Key key, this.title}) : super(key: key);

  //final String title;

  @override
  _StudentMainScreenMinorState createState() => new _StudentMainScreenMinorState();
}

class _StudentMainScreenMinorState extends State<StudentMainScreenMinor> {
  int statusCode = 0;

  @override
  Widget build(BuildContext context) {
    //int statusCode = 0;

    return new Scaffold(
      backgroundColor: Color(0xff65646a),
      body: Container(
          child: FutureBuilder(
        future: studentInfo(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) {
            return new Scaffold(
              backgroundColor: Color(0xff65646a),
              body: new Center(
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset("assets/images/image0.png"),
                  ],
                ),
              ),
            );
          } else {
            return new Center(
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
                              new Text(
                                  " Welcome! ${snapshot.data.firstname} ${snapshot.data.lastname} \n Minor",
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
                                percent: 0,
                                center: new Text("0",
                                    style: TextStyle(
                                        color: Color(0xffcf4411),
                                        fontSize: 30)),
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
                            Padding(
                              padding: EdgeInsets.all(0),
                              child: NiceButton(
                                mini: true,
                                icon: Icons.add,
                                text: "hi",
                                background: Color(0xffcf4411),
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddAClass()),
                                  );
                                },
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
                        height: 48.0 * 9,
                        decoration: BoxDecoration(
                            gradient: LinearGradient(
                                colors: [Color(0xffebebe8), Color(0xffebebe8)]),
                            borderRadius: BorderRadius.circular(6.0),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black.withOpacity(.3),
                                  offset: Offset(0.0, 8.0),
                                  blurRadius: 8.0),
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
                                          style: TextStyle(
                                              color: Color(0xffcf4411))),
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
                                          style: TextStyle(
                                              color: Color(0xffcf4411))),
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
                                          style: TextStyle(
                                              color: Color(0xffcf4411))),
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
            );
          }
        },
      )),
    );
  }
}

// String firstname = "USER";
// String lastname = "USER";
// String email = "USEREMAIL";
// String gpa = "0.0";
// String catalogyear = "####-####";
// String classification = "Undergrad";
// String hours = "0";
// String advancedhours = "0";
// String advancedcshours = "0";
// double perA = 0.32;

