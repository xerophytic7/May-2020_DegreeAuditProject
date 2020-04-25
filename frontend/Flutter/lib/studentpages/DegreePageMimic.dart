import 'dart:convert';
import 'package:seniordesign/popup.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:seniordesign/globals/globals.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

final storage = new FlutterSecureStorage();

class SizeConfig {
  static MediaQueryData _mediaQueryData;
  static double screenWidth;
  static double screenHeight;
  static double blockSizeHorizontal;
  static double blockSizeVertical;

  void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
  }
  // Example
  // Widget build(BuildContext context) {
  //   SizeConfig().init(context);
  //   double deviceWidth = SizeConfig.blockSizeHorizontal;
  //   double deviceHeight = SizeConfig.blockSizeVertical;

}

class Student {
  final String firstname;
  final String lastname;
  final String email;
  final String gpa;
  final String catalogyear;
  final String classification;
  final String hours;
  final String advancedhours;
  final String advancedcshours;

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

class Course {
  final int courseID;
  final String courseDept;
  final int courseNum;
  final String name;
  final String institution;

  Course(this.courseID, this.courseDept, this.courseNum, this.name,
      this.institution);
}

Future<List<dynamic>> CoursesInfo() async {
  //String username,password,fn,ln,id;
  String value = await storage.read(key: "token");
  print("This is the supposed Token $value");
  final response = await http.get(
    "$address/all/Courses",
    headers: {HttpHeaders.authorizationHeader: "Bearer $value"},
  );

  if (response.statusCode != 200) return null;

  List<dynamic> data = json.decode(response.body);
  return data;
}

Future<List<Course>> _getCourses() async {
  String value = await storage.read(key: "token");

  var response = await http.get(
    "$address/all/Courses",
    headers: {HttpHeaders.authorizationHeader: "Bearer $value"},
  );

  var data = json.decode(response.body);

  List<Course> courses = [];

  for (var i in data) {
    Course course = Course(i["CourseID"], i["CourseDept"], i["CourseNum"],
        i["Name"], i["Institution"]);

    courses.add(course);
  }
  print("This is the number of courses => ${courses.length}");
  return courses;
}

class DegreePageMimic extends StatefulWidget {
  //DegreePageMimic({Key key, this.title}) : super(key: key);

  //final String title;

  @override
  _DegreePageMimicState createState() => new _DegreePageMimicState();
}

class _DegreePageMimicState extends State<DegreePageMimic> {
  int statusCode = 0;

  @override
  Widget build(BuildContext context) {
    //StudentInfo();
    // Future<Map<String, dynamic>> data = CoursesInfo();

    // print(data);
    //need a future builder
    return new FutureBuilder(
      future: _getCourses(),
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
          return Scaffold(
            backgroundColor: Color(0xff65646a),
            body: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int i) {
                return ListTile(
                  title: Text(snapshot.data[i].name,
                      style: TextStyle(color: Color(0xffebebe8))),
                  subtitle: Text(
                      "${snapshot.data[i].courseDept} ${snapshot.data[i].courseNum}"),
                  onTap: () => showDialog(
                    context: context,
                    builder: (_) => Popup(message: "Implement Later"),
                  ),
                  trailing: Text("+"),
                  leading: Text("♥"),
                );
              },
            ),
          );
        }
      },
    );
  }
}
