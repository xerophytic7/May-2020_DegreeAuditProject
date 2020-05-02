import 'dart:convert';
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

class Course {
  final int courseID;
  final String courseDept;
  final int courseNum;
  final String name;
  final String institution;
  final String grade;
  final String semester;
  final bool taken;

  Course(this.courseID, this.courseDept, this.courseNum, this.name,
      this.institution, this.grade, this.semester, this.taken);
}

Future<List<Course>> _getCourses() async {
  String value = await storage.read(key: "token");

  //A will have the entire courses
  var responseA = await http.get(
    "$address/all/Courses",
    headers: {HttpHeaders.authorizationHeader: "Bearer $value"},
  );
  if (responseA.statusCode != 200) return null;
  //B will have the taken Courses by the student
  var responseB = await http.get(
    "$address/myCourses",
    headers: {HttpHeaders.authorizationHeader: "Bearer $value"},
  );
  if (responseB.statusCode != 200) return null;

  var dataA = json.decode(responseA.body);
  var dataB = json.decode(responseB.body);

  List<Course> allCourses = [];
  List<int> courseIDtoSkip = [];

  for (var i in dataB) {
    Course myCourse = Course(i["CourseID"], i["CourseDept"], i["CourseNum"],
        i["Name"], i["Institution"], i["Grade"], i["Semester"], true);

    allCourses.add(myCourse);
    courseIDtoSkip.add(i["CourseID"]);
  }

  //Adds the rest of the courses except the it doesnt add the ones you have taken.
  bool flag = true;
  for (var i in dataA) {
    for (var j in courseIDtoSkip) {
      if (j == i["CourseID"]) {
        flag = false;
      }
    }
    if (flag) {
      Course course = Course(i["CourseID"], i["CourseDept"], i["CourseNum"],
          i["Name"], i["Institution"], "null", "null", false);
      allCourses.add(course);
    }
    flag = true;
  }

  return allCourses;
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

Future<Student> _getUser() async {
  var response = await http.get(
      "$address/user?StudentID=?${await storage.read(key: "studentId")}}",
      headers: {
        HttpHeaders.authorizationHeader:
            "Bearer ${await storage.read(key: "token")}"
      });

  if (response.statusCode != 200) return null;

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

class SpecificStudent extends StatefulWidget {
  //SpecificStudent({Key key, this.title}) : super(key: key);

  //final String title;

  @override
  _SpecificStudentState createState() => new _SpecificStudentState();
}

class _SpecificStudentState extends State<SpecificStudent> {
  @override
  Widget build(BuildContext context) {
    return new FutureBuilder(
      future: _getUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.data == null) {
          print("snapshot is null :O");
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
          print("snapshot is not null");
          return Scaffold(
            backgroundColor: Color(0xff65646a),
            body: Text("hi"),
          );
        }
      },
    );
  }
}
